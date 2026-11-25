import Foundation
import MizonAPI
#if canImport(Darwin)
import Darwin
#elseif canImport(Glibc)
import Glibc
#endif

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
    private enum Source: Sendable {
        case direct(URL)
        case managed(api: MizonApi, endpoint: URL, baseURL: URL, credential: UInt64)

        var localFile: URL? {
            if case .direct(let url) = self, url.isFileURL { return url }
            return nil
        }
    }

    private enum DirectResponse {
        case range(Data)
        case complete(URLSession.AsyncBytes)
    }

    private let http: URLSession
    private let cacheRoot: URL
    private static let cacheLeases = CacheLeases()
    private var publicStorageSession: URLSession?
    public init(session: URLSession = .shared, cacheRoot: URL) {
        self.http = session; self.cacheRoot = cacheRoot.standardizedFileURL
    }
    deinit { publicStorageSession?.invalidateAndCancel() }

    public func getCachedFilePath(_ info: MediaResponse) throws -> URL {
        let final = try cacheFilePath(info)
        try FileManager.default.createDirectory(at: final.deletingLastPathComponent(), withIntermediateDirectories: true)
        return final
    }

    private func cacheFilePath(_ info: MediaResponse) throws -> URL {
        guard cacheRoot.isFileURL else { throw BaseApiError(code: 102, title: "Invalid media cache root") }
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
        try validateCachePath(final, error: "Cache path escapes root")
        return final
    }

    private func validateCachePath(_ entry: URL, error: String) throws {
        let root = try Self.physicalCachePath(cacheRoot)
        let path = try Self.physicalCachePath(entry)
        let prefix = root == "/" ? root : root + "/"
        guard path != root, path.hasPrefix(prefix) else { throw BaseApiError(code: 102, title: error) }
    }

    private static func physicalCachePath(_ url: URL) throws -> String {
        if let path = realpath(url.path, nil) {
            defer { free(path) }
            return String(cString: path)
        }
        guard errno == ENOENT else { throw cacheFileError() }

        // Foundation can use "/tmp" for an existing directory and "/private/tmp"
        // for its missing child. Resolve the existing ancestor through the same
        // filesystem API, then append missing path components without changing aliases.
        var metadata = stat()
        if lstat(url.path, &metadata) == 0 {
            throw BaseApiError(code: 102, title: "Invalid cached media symlink")
        }
        guard errno == ENOENT else { throw cacheFileError() }
        let parent = url.deletingLastPathComponent()
        guard parent.path != url.path else { throw cacheFileError() }
        let directory = try physicalCachePath(parent)
        return (directory == "/" ? directory : directory + "/") + url.lastPathComponent
    }

    /// Removes the completed file and its partial download after a caller detects unusable cached content.
    /// Missing files are harmless. An active download of the same cache entry is left alone.
    public func invalidateCachedDownload(_ info: MediaResponse) throws {
        let final = try cacheFilePath(info)
        let partial = final.appendingPathExtension("part")
        let lease = try Self.cacheLeases.acquire(final: final, partial: partial)
        defer { Self.cacheLeases.release(lease) }

        let flags = O_RDONLY | O_DIRECTORY | O_NOFOLLOW | O_CLOEXEC
        var directory = open(try Self.physicalCachePath(cacheRoot), flags)
        if directory < 0 && errno == ENOENT { return }
        guard directory >= 0 else { throw Self.cacheFileError() }
        defer { _ = close(directory) }

        let folder = final.deletingLastPathComponent()
        // Anchor operations to open directories so a symlink cannot redirect a deletion.
        for component in [folder.deletingLastPathComponent().lastPathComponent, folder.lastPathComponent] {
            let child = openat(directory, component, flags)
            if child < 0 && errno == ENOENT { return }
            guard child >= 0 else { throw Self.cacheFileError() }
            _ = close(directory)
            directory = child
        }

        var present: [String] = []
        for name in [partial.lastPathComponent, final.lastPathComponent] {
            var metadata = stat()
            if fstatat(directory, name, &metadata, AT_SYMLINK_NOFOLLOW) != 0 {
                if errno == ENOENT { continue }
                throw Self.cacheFileError()
            }
            guard metadata.st_mode & mode_t(S_IFMT) == mode_t(S_IFREG) else {
                throw BaseApiError(code: 102, title: "Invalid cached media file")
            }
            present.append(name)
        }
        for name in present {
            // Discard the partial first so a later retry cannot promote its stale bytes.
            if unlinkat(directory, name, 0) != 0 && errno != ENOENT { throw Self.cacheFileError() }
        }
    }

    private static func cacheFileError() -> POSIXError {
        POSIXError(POSIXErrorCode(rawValue: errno) ?? .EIO)
    }

    public func isCached(_ info: MediaResponse) throws -> Bool {
        let path = try getCachedFilePath(info)
        guard let size = try? path.resourceValues(forKeys: [.fileSizeKey]).fileSize else { return false }
        return info.fileSize >= 0 && Int64(size) == info.fileSize
    }
    public func downloadToCache(_ info: MediaResponse, storageURL: URL, session: DownloadSession? = nil,
                                progress: (@Sendable (MediaDownloadProgress) -> Void)? = nil) async throws -> URL {
        try await downloadToCache(info, source: .direct(storageURL), session: session, progress: progress)
    }

    /// Downloads HTTPS storage directly and resolves server-local files through the authenticated API.
    public func downloadToCache(_ info: MediaResponse, api: MizonApi, endpoints: Endpoints, session: DownloadSession? = nil,
                                progress: (@Sendable (MediaDownloadProgress) -> Void)? = nil) async throws -> URL {
        let source = try await registeredSource(for: info, api: api, endpoints: endpoints)
        return try await downloadToCache(info, source: source, session: session, progress: progress)
    }

    /// Returns a trusted piece manifest when the media origin permits sharing and the table matches this file version.
    public func peerManifest(for info: MediaResponse, api: MizonApi, endpoints: Endpoints) async throws -> VerifiedMediaManifest? {
        guard VerifiedMediaManifest.supports(info) else { return nil }
        let operation = PeerMediaManifestOperation(.init(mediaPublicId: info.mediaPublicId), endpoints: endpoints)
        guard let response = try await api.readTrustedMediaManifest(operation.apiRequest, baseURL: endpoints.baseURL,
            limit: VerifiedMediaManifest.maximumEnvelopeBytes), let manifest = VerifiedMediaManifest(fileHash: response.fileHash,
                fileSize: response.fileSize, chunkSize: response.chunkSize, pieceSha256: response.pieceSha256),
              manifest.matches(info) else { return nil }
        return manifest
    }

    /// Reads a bounded piece from its origin and verifies its SHA-256 before returning bytes.
    public func readOriginPiece(for info: MediaResponse, manifest: VerifiedMediaManifest, index: Int, api: MizonApi,
                                endpoints: Endpoints) async throws -> Data {
        try Task.checkCancellation()
        guard manifest.matches(info), let range = manifest.range(for: index) else {
            throw BaseApiError(code: 102, title: "Invalid verified media piece")
        }
        let generation = try await api.mediaCredentialGeneration()
        let source = try await registeredSource(for: info, api: api, endpoints: endpoints, credential: generation)
        let data: Data
        switch source {
        case .managed(let api, let endpoint, let baseURL, let credential):
            data = try await api.readManagedMediaRange(range, fileSize: info.fileSize, from: endpoint,
                                                       apiBaseURL: baseURL, credential: credential)
        case .direct(let url):
            var request = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: 30)
            request.assumesHTTP3Capable = true
            request.httpShouldHandleCookies = false
            data = try await BoundedMediaTransport.readRange(range, fileSize: info.fileSize, request: request, session: uncredentialedStorageSession())
        }
        try await api.verifyMediaCredentialGeneration(generation)
        guard manifest.verify(data, at: index) else { throw BaseApiError(code: 102, title: "Media piece verification failed") }
        return data
    }

    private func uncredentialedStorageSession() -> URLSession {
        if let publicStorageSession { return publicStorageSession }
        // Keep the injected public network configuration and remove session credentials and cached state.
        let configuration = http.configuration
        configuration.httpAdditionalHeaders = nil
        configuration.httpShouldSetCookies = false
        configuration.httpCookieStorage = nil
        configuration.urlCredentialStorage = nil
        configuration.urlCache = nil
        let session = URLSession(configuration: configuration)
        publicStorageSession = session
        return session
    }

    private func registeredSource(for info: MediaResponse, api: MizonApi, endpoints: Endpoints,
                                  credential: UInt64? = nil) async throws -> Source {
        guard let storageURL = URL(string: info.storagePath) else {
            throw BaseApiError(code: 102, title: "Invalid media storage URL")
        }
        if !storageURL.isFileURL {
            guard HTTPSStorageRedirects.allows(storageURL) else {
                throw BaseApiError(code: 102, title: "Invalid media storage URL")
            }
            return .direct(storageURL)
        }
        guard info.fileSize > 0, var route = URLComponents(url: endpoints.medias.mediaContent, resolvingAgainstBaseURL: false) else {
            throw BaseApiError(code: 102, title: "Invalid registered media")
        }
        route.queryItems = [URLQueryItem(name: "MediaPublicId", value: info.mediaPublicId.uuidString.lowercased())]
        guard let endpoint = route.url else { throw BaseApiError(code: 102, title: "Invalid media endpoint") }
        if let credential { return .managed(api: api, endpoint: endpoint, baseURL: endpoints.baseURL, credential: credential) }
        return try await .managed(api: api, endpoint: endpoint, baseURL: endpoints.baseURL, credential: api.mediaCredentialGeneration())
    }

    private func downloadToCache(_ info: MediaResponse, source: Source, session: DownloadSession?,
                                 progress: (@Sendable (MediaDownloadProgress) -> Void)?) async throws -> URL {
        let (stream, worker) = startDownload(info, source: source, session: session, allowsCompleteHTTPS: true)
        do {
            for try await chunk in stream {
                progress?(MediaDownloadProgress(totalDownloaded: chunk.totalDownloaded, fileSize: chunk.fileSize,
                                               instantaneousSpeedBytesPerSecond: chunk.instantaneousSpeedBytesPerSecond))
            }
            try Task.checkCancellation()
        } catch {
            worker.cancel()
            // The stream can report cancellation before its producer closes the file and releases the lease.
            await worker.value
            throw error
        }
        return try getCachedFilePath(info)
    }
    public func download(_ info: MediaResponse, storageURL: URL, session: DownloadSession? = nil) -> AsyncThrowingStream<DownloadChunk, any Error> {
        startDownload(info, source: .direct(storageURL), session: session, allowsCompleteHTTPS: false).stream
    }

    private func startDownload(_ info: MediaResponse, source: Source, session: DownloadSession?, allowsCompleteHTTPS: Bool)
        -> (stream: AsyncThrowingStream<DownloadChunk, any Error>, worker: Task<Void, Never>) {
        let (stream, continuation) = AsyncThrowingStream<DownloadChunk, any Error>.makeStream(bufferingPolicy: .bufferingOldest(1))
        let worker = Task {
            do {
                try await withThrowingTaskGroup(of: Void.self) { group in
                    group.addTask {
                        try await self.performDownload(info, source: source, control: session,
                                                       allowsCompleteHTTPS: allowsCompleteHTTPS, continuation: continuation)
                    }
                    if let session { group.addTask { try await session.waitForCancellation() } }
                    defer { group.cancelAll() }
                    try await group.next()
                }
                continuation.finish()
            } catch { continuation.finish(throwing: error) }
        }
        continuation.onTermination = { @Sendable _ in worker.cancel() }
        return (stream, worker)
    }
    private func performDownload(_ info: MediaResponse, source: Source, control: DownloadSession?,
                                  allowsCompleteHTTPS: Bool,
                                  continuation: AsyncThrowingStream<DownloadChunk, any Error>.Continuation) async throws {
        try Task.checkCancellation(); try await control?.checkpoint()
        let final = try getCachedFilePath(info)
        let partial = final.appendingPathExtension("part")
        let lease = try Self.cacheLeases.acquire(final: final, partial: partial)
        defer { Self.cacheLeases.release(lease) }
        guard info.fileSize >= 0, info.chunkSize > 0, info.chunkSize <= 64 * 1024 * 1024 else {
            throw BaseApiError(code: 102, title: "Invalid media size or chunk size")
        }
        let fileSize = try source.localFile.map { Int64(try $0.resourceValues(forKeys: [.fileSizeKey]).fileSize ?? 0) } ?? info.fileSize
        if let size = try? final.resourceValues(forKeys: [.fileSizeKey]).fileSize, Int64(size) == fileSize {
            try await yield(DownloadChunk(data: Data(), chunkIndex: 0, totalDownloaded: fileSize,
                instantaneousSpeedBytesPerSecond: 0, fileSize: fileSize, path: final, isLastChunk: true), to: continuation)
            return
        }
        try validateCachePath(partial, error: "Invalid partial cache path")
        if !FileManager.default.fileExists(atPath: partial.path) { FileManager.default.createFile(atPath: partial.path, contents: nil) }
        let output = try FileHandle(forWritingTo: partial)
        defer { try? output.close() }
        var position = Int64(try output.seekToEnd())
        if position > fileSize { try output.truncate(atOffset: 0); position = 0 }
        var index = Int(position / Int64(info.chunkSize))
        while position < fileSize {
            try Task.checkCancellation(); try await control?.checkpoint()
            let end = position + min(Int64(info.chunkSize), fileSize - position) - 1
            let started = ContinuousClock.now
            var bytes: Data?
            var complete: URLSession.AsyncBytes?
            for attempt in 0..<6 {
                do {
                    switch source {
                    case .managed(let api, let endpoint, let baseURL, let credential):
                        bytes = try await api.readManagedMediaRange(position...end, fileSize: fileSize, from: endpoint,
                                                                    apiBaseURL: baseURL, credential: credential)
                    case .direct(let storageURL) where storageURL.isFileURL:
                        let input = try FileHandle(forReadingFrom: storageURL)
                        defer { try? input.close() }
                        try input.seek(toOffset: UInt64(position))
                        bytes = try input.read(upToCount: Int(end - position + 1)) ?? Data()
                    case .direct(let storageURL):
                        switch try await readDirectResponse(storageURL, range: position...end,
                                                             fileSize: fileSize, allowsCompleteHTTPS: allowsCompleteHTTPS) {
                        case .range(let data): bytes = data
                        case .complete(let body): complete = body
                        }
                    }
                    if complete != nil { break }
                    guard bytes?.count == Int(end - position + 1) else { throw BaseApiError(code: 102, title: "Truncated media chunk") }
                    break
                } catch {
                    bytes = nil
                    if Task.isCancelled || error is CancellationError || attempt == 5 { throw error }
                    if case .direct = source, let apiError = error as? BaseApiError,
                       apiError.code != 429, !(500...599).contains(apiError.code) { throw error }
                    if case .managed = source, let apiError = error as? BaseApiError,
                       apiError.code != 429, !(500...599).contains(apiError.code) { throw error }
                    try await control?.checkpoint()
                    try await Task.sleep(for: .milliseconds(min(10_000, 200 * (1 << attempt))))
                }
            }
            if let complete {
                try await writeCompleteResponse(complete, fileSize: fileSize, output: output, partial: partial,
                                                final: final, control: control, continuation: continuation)
                return
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

    private func readDirectResponse(_ url: URL, range: ClosedRange<Int64>, fileSize: Int64,
                                    allowsCompleteHTTPS: Bool) async throws -> DirectResponse {
        let isHTTPS = HTTPSStorageRedirects.allows(url)
        guard isHTTPS || (url.scheme?.lowercased() == "http" && url.host?.isEmpty == false && url.user == nil && url.password == nil) else {
            throw BaseApiError(code: 102, title: "Invalid media storage URL")
        }
        var request = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: 30)
        request.assumesHTTP3Capable = isHTTPS
        request.httpShouldHandleCookies = false
        request.setValue("*/*", forHTTPHeaderField: "Accept")
        request.setValue("identity", forHTTPHeaderField: "Accept-Encoding")
        request.setValue("bytes=\(range.lowerBound)-\(range.upperBound)", forHTTPHeaderField: "Range")
        let (body, response) = try await uncredentialedStorageSession().bytes(for: request, delegate: HTTPSStorageRedirects())
        do {
            guard let response = response as? HTTPURLResponse else {
                throw BaseApiError(code: 107, title: "Invalid storage response")
            }
            if response.statusCode == 206 {
                let contentRange = "bytes \(range.lowerBound)-\(range.upperBound)/\(fileSize)"
                guard response.value(forHTTPHeaderField: "Content-Range") == contentRange else {
                    throw BaseApiError(code: 102, title: "Invalid Content-Range")
                }
            } else if response.statusCode == 200 && allowsCompleteHTTPS && isHTTPS {
                let advertisedSize = response.expectedContentLength
                guard response.value(forHTTPHeaderField: "Content-Range") == nil,
                      advertisedSize < 0 || advertisedSize == fileSize else {
                    throw BaseApiError(code: 102, title: "Invalid media response length")
                }
                return .complete(body)
            } else if !(response.statusCode == 200 && range.lowerBound == 0 && range.upperBound == fileSize - 1) {
                throw BaseApiError(code: response.statusCode, title: "Storage did not honor byte range")
            }
            let count = Int(range.upperBound - range.lowerBound + 1)
            return .range(try await BoundedMediaTransport.readBody(body, response: response, limit: count, exact: true))
        } catch {
            body.task.cancel()
            throw error
        }
    }

    private func writeCompleteResponse(_ body: URLSession.AsyncBytes, fileSize: Int64, output: FileHandle,
                                       partial: URL, final: URL, control: DownloadSession?,
                                       continuation: AsyncThrowingStream<DownloadChunk, any Error>.Continuation) async throws {
        defer { body.task.cancel() }
        try Task.checkCancellation(); try await control?.checkpoint()
        try output.truncate(atOffset: 0)
        try output.seek(toOffset: 0)
        let blockSize = 256 * 1024
        var block = Data(capacity: Int(min(Int64(blockSize), fileSize)))
        var received: Int64 = 0
        var index = 0
        var started = ContinuousClock.now
        for try await byte in body {
            guard received < fileSize else { throw BaseApiError(code: 102, title: "Oversized media response") }
            block.append(byte)
            received += 1
            // Hold the last block until EOF proves that the response has exactly the registered length.
            if block.count == blockSize && received < fileSize {
                try Task.checkCancellation(); try await control?.checkpoint()
                try output.write(contentsOf: block)
                let duration = started.duration(to: .now)
                let seconds = Double(duration.components.seconds) + Double(duration.components.attoseconds) / 1e18
                try await yield(DownloadChunk(data: block, chunkIndex: index, totalDownloaded: received,
                    instantaneousSpeedBytesPerSecond: seconds > 0 ? Double(block.count) / seconds : 0,
                    fileSize: fileSize, path: partial, isLastChunk: false), to: continuation)
                index += 1
                block = Data(capacity: Int(min(Int64(blockSize), fileSize - received)))
                started = .now
            }
        }
        guard received == fileSize else { throw BaseApiError(code: 102, title: "Truncated media response") }
        try Task.checkCancellation(); try await control?.checkpoint()
        try output.write(contentsOf: block)
        try output.synchronize()
        try promote(partial, to: final)
        let duration = started.duration(to: .now)
        let seconds = Double(duration.components.seconds) + Double(duration.components.attoseconds) / 1e18
        try await yield(DownloadChunk(data: block, chunkIndex: index, totalDownloaded: received,
            instantaneousSpeedBytesPerSecond: seconds > 0 ? Double(block.count) / seconds : 0,
            fileSize: fileSize, path: final, isLastChunk: true), to: continuation)
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
        if rename(partial.path, final.path) != 0 { throw Self.cacheFileError() }
    }

    private final class CacheLeases: @unchecked Sendable {
        private let lock = NSLock()
        private var leased: Set<String> = []

        func acquire(final: URL, partial: URL) throws -> Set<String> {
            let paths = try Set([physicalCachePath(final), physicalCachePath(partial)])
            try lock.withLock {
                guard leased.isDisjoint(with: paths) else {
                    throw BaseApiError(code: 102, title: "Download already in progress")
                }
                leased.formUnion(paths)
            }
            return paths
        }

        func release(_ paths: Set<String>) {
            lock.withLock { leased.subtract(paths) }
        }
    }
}

private final class HTTPSStorageRedirects: NSObject, URLSessionTaskDelegate, Sendable {
    static func allows(_ url: URL?) -> Bool {
        guard let url else { return false }
        return url.scheme?.lowercased() == "https" && url.host?.isEmpty == false && url.user == nil && url.password == nil
    }

    func urlSession(_ session: URLSession, task: URLSessionTask, willPerformHTTPRedirection response: HTTPURLResponse,
                    newRequest request: URLRequest, completionHandler: @escaping @Sendable (URLRequest?) -> Void) {
        guard Self.allows(request.url) else { completionHandler(nil); return }
        var redirected = request
        redirected.httpShouldHandleCookies = false
        redirected.assumesHTTP3Capable = true
        redirected.setValue(nil, forHTTPHeaderField: "Authorization")
        redirected.setValue(nil, forHTTPHeaderField: "Cookie")
        redirected.setValue(task.originalRequest?.value(forHTTPHeaderField: "Range"), forHTTPHeaderField: "Range")
        redirected.setValue("identity", forHTTPHeaderField: "Accept-Encoding")
        completionHandler(redirected)
    }
}
