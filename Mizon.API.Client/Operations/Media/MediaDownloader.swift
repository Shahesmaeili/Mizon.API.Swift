import Foundation
import MizonAPI

public actor DownloadSession {
    public private(set) var isPaused = false
    private var isCancelled = false
    public init() {}
    public func pause() { isPaused = true }
    public func resume() { isPaused = false }
    public func cancel() { isCancelled = true }
    func waitForCancellation() async throws {
        while !isCancelled { try await Task.sleep(for: .milliseconds(50)) }
        throw CancellationError()
    }
    func checkpoint() async throws {
        repeat {
            try Task.checkCancellation()
            if isCancelled { throw CancellationError() }
            if !isPaused { return }
            try await Task.sleep(for: .milliseconds(100))
        } while true
    }
}

public struct MediaDownloadProgress: Sendable {
    public let totalDownloaded: Int64
    public let fileSize: Int64
    public let instantaneousSpeedBytesPerSecond: Double
    public var percentage: Double { fileSize > 0 ? min(100, Double(totalDownloaded) / Double(fileSize) * 100) : 0 }
}
public struct DownloadChunk: Sendable {
    public let data: Data
    public let chunkIndex: Int
    public let totalDownloaded: Int64
    public let instantaneousSpeedBytesPerSecond: Double
    public let fileSize: Int64
    public let path: URL
    public let isLastChunk: Bool
}

public actor MediaDownloader {
    private let http: URLSession
    private let cacheRoot: URL
    private var active: Set<URL> = []
    public init(session: URLSession = .shared, cacheRoot: URL) {
        self.http = session; self.cacheRoot = cacheRoot.standardizedFileURL
    }
    public func getCachedFilePath(_ info: MediaResponse) throws -> URL {
        func component(_ value: String) throws -> String {
            guard !value.isEmpty, value != ".", value != "..", !value.contains("/"), !value.contains("\\"), !value.contains("\0") else {
                throw BaseApiError(code: 102, title: "Invalid media cache path")
            }
            return value
        }
        let category = try component(info.category.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ? "others" : info.category)
        let id = try component(info.fileHash.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ? info.mediaPublicId.uuidString.lowercased() : info.fileHash)
        let name = try component(info.fileName)
        let folder = cacheRoot.appendingPathComponent(category).appendingPathComponent(id)
        let final = folder.appendingPathComponent(name)
        // Symlink resolution prevents pre-existing cache symlinks from escaping the root.
        let root = cacheRoot.resolvingSymlinksInPath().path + "/"
        guard final.resolvingSymlinksInPath().path.hasPrefix(root) else { throw BaseApiError(code: 102, title: "Cache path escapes root") }
        try FileManager.default.createDirectory(at: folder, withIntermediateDirectories: true)
        return final
    }
    public func isCached(_ info: MediaResponse) throws -> Bool {
        let path = try getCachedFilePath(info)
        guard let size = try? path.resourceValues(forKeys: [.fileSizeKey]).fileSize else { return false }
        return info.fileSize >= 0 && Int64(size) == info.fileSize
    }
    public func downloadToCache(_ info: MediaResponse, storageURL: URL, session: DownloadSession? = nil,
                                progress: (@Sendable (MediaDownloadProgress) -> Void)? = nil) async throws -> URL {
        for try await chunk in download(info, storageURL: storageURL, session: session) {
            progress?(MediaDownloadProgress(totalDownloaded: chunk.totalDownloaded, fileSize: chunk.fileSize,
                                           instantaneousSpeedBytesPerSecond: chunk.instantaneousSpeedBytesPerSecond))
        }
        return try getCachedFilePath(info)
    }
    public func download(_ info: MediaResponse, storageURL: URL, session: DownloadSession? = nil) -> AsyncThrowingStream<DownloadChunk, any Error> {
        let (stream, continuation) = AsyncThrowingStream<DownloadChunk, any Error>.makeStream(bufferingPolicy: .bufferingOldest(1))
        let worker = Task {
            do {
                try await withThrowingTaskGroup(of: Void.self) { group in
                    group.addTask { try await self.performDownload(info, storageURL: storageURL, control: session, continuation: continuation) }
                    if let session { group.addTask { try await session.waitForCancellation() } }
                    defer { group.cancelAll() }
                    try await group.next()
                }
                continuation.finish()
            } catch { continuation.finish(throwing: error) }
        }
        continuation.onTermination = { @Sendable _ in worker.cancel() }
        return stream
    }
    private func performDownload(_ info: MediaResponse, storageURL: URL, control: DownloadSession?,
                                  continuation: AsyncThrowingStream<DownloadChunk, any Error>.Continuation) async throws {
        try Task.checkCancellation(); try await control?.checkpoint()
        let final = try getCachedFilePath(info)
        guard active.insert(final).inserted else { throw BaseApiError(code: 102, title: "Download already in progress") }
        defer { active.remove(final) }
        guard info.fileSize >= 0, info.chunkSize > 0, info.chunkSize <= 64 * 1024 * 1024 else {
            throw BaseApiError(code: 102, title: "Invalid media size or chunk size")
        }
        let fileSize = storageURL.isFileURL ? Int64(try storageURL.resourceValues(forKeys: [.fileSizeKey]).fileSize ?? 0) : info.fileSize
        if let size = try? final.resourceValues(forKeys: [.fileSizeKey]).fileSize, Int64(size) == fileSize {
            try await yield(DownloadChunk(data: Data(), chunkIndex: 0, totalDownloaded: fileSize,
                instantaneousSpeedBytesPerSecond: 0, fileSize: fileSize, path: final, isLastChunk: true), to: continuation)
            return
        }
        let partial = final.appendingPathExtension("part")
        guard partial.resolvingSymlinksInPath().path.hasPrefix(cacheRoot.resolvingSymlinksInPath().path + "/") else {
            throw BaseApiError(code: 102, title: "Invalid partial cache path")
        }
        if !FileManager.default.fileExists(atPath: partial.path) { FileManager.default.createFile(atPath: partial.path, contents: nil) }
        let output = try FileHandle(forWritingTo: partial)
        defer { try? output.close() }
        var position = Int64(try output.seekToEnd())
        if position > fileSize { try output.truncate(atOffset: 0); position = 0 }
        var index = Int(position / Int64(info.chunkSize))
        while position < fileSize {
            try Task.checkCancellation(); try await control?.checkpoint()
            let end = min(position + Int64(info.chunkSize) - 1, fileSize - 1)
            let started = ContinuousClock.now
            var bytes: Data?
            for attempt in 0..<6 {
                do {
                    if storageURL.isFileURL {
                        let input = try FileHandle(forReadingFrom: storageURL)
                        defer { try? input.close() }
                        try input.seek(toOffset: UInt64(position))
                        bytes = try input.read(upToCount: Int(end - position + 1)) ?? Data()
                    } else {
                        var request = URLRequest(url: storageURL, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: 30)
                        request.setValue("bytes=\(position)-\(end)", forHTTPHeaderField: "Range")
                        let (data, response) = try await http.data(for: request)
                        guard let response = response as? HTTPURLResponse else { throw BaseApiError(code: 107, title: "Invalid storage response") }
                        if response.statusCode == 206 {
                            guard response.value(forHTTPHeaderField: "Content-Range") == "bytes \(position)-\(end)/\(fileSize)" else {
                                throw BaseApiError(code: 102, title: "Invalid Content-Range")
                            }
                        } else if !(response.statusCode == 200 && position == 0 && end == fileSize - 1) {
                            throw BaseApiError(code: response.statusCode, title: "Storage did not honor byte range")
                        }
                        bytes = data
                    }
                    guard bytes?.count == Int(end - position + 1) else { throw BaseApiError(code: 102, title: "Truncated media chunk") }
                    break
                } catch {
                    bytes = nil
                    if Task.isCancelled || error is CancellationError || attempt == 5 { throw error }
                    try await control?.checkpoint()
                    try await Task.sleep(for: .milliseconds(min(10_000, 200 * (1 << attempt))))
                }
            }
            guard let data = bytes else { throw BaseApiError(code: 102, title: "Missing media data") }
            try Task.checkCancellation(); try await control?.checkpoint()
            try output.seek(toOffset: UInt64(position)); try output.write(contentsOf: data); try output.synchronize()
            position += Int64(data.count)
            let elapsed = started.duration(to: .now)
            let seconds = Double(elapsed.components.seconds) + Double(elapsed.components.attoseconds) / 1e18
            let last = position == fileSize
            if last { try promote(partial, to: final) }
            try await yield(DownloadChunk(data: data, chunkIndex: index, totalDownloaded: position,
                instantaneousSpeedBytesPerSecond: seconds > 0 ? Double(data.count) / seconds : 0,
                fileSize: fileSize, path: last ? final : partial, isLastChunk: last), to: continuation)
            index += 1
        }
        if FileManager.default.fileExists(atPath: partial.path) {
            try promote(partial, to: final)
            try await yield(DownloadChunk(data: Data(), chunkIndex: index, totalDownloaded: fileSize,
                instantaneousSpeedBytesPerSecond: 0, fileSize: fileSize, path: final, isLastChunk: true), to: continuation)
        }
    }
    private func yield(_ chunk: DownloadChunk, to continuation: AsyncThrowingStream<DownloadChunk, any Error>.Continuation) async throws {
        // Keep at most one chunk queued. A slow consumer must not buffer a whole file.
        while true {
            try Task.checkCancellation()
            switch continuation.yield(chunk) {
            case .enqueued: return
            case .terminated: throw CancellationError()
            case .dropped: try await Task.sleep(for: .milliseconds(10))
            @unknown default: throw CancellationError()
            }
        }
    }
    private func promote(_ partial: URL, to final: URL) throws {
        if FileManager.default.fileExists(atPath: final.path) { try FileManager.default.removeItem(at: final) }
        try FileManager.default.moveItem(at: partial, to: final)
    }
}
