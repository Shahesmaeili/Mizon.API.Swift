import Foundation
import Testing
import CZlib
@testable import MizonAPI
import MizonAPIClient

private final class MockProtocol: URLProtocol, @unchecked Sendable {
    static let lock = NSLock()
    nonisolated(unsafe) static var handler: (@Sendable (URLRequest) throws -> (Int, Data, [String: String]))?
    static func install(_ value: @escaping @Sendable (URLRequest) throws -> (Int, Data, [String: String])) {
        lock.lock(); defer { lock.unlock() }; handler = value
    }
    override class func canInit(with request: URLRequest) -> Bool { true }
    override class func canonicalRequest(for request: URLRequest) -> URLRequest { request }
    override func startLoading() {
        Self.lock.lock(); let handler = Self.handler; Self.lock.unlock()
        do {
            let (code, data, headers) = try handler!(request)
            client?.urlProtocol(self, didReceive: HTTPURLResponse(url: request.url!, statusCode: code, httpVersion: "HTTP/1.1", headerFields: headers)!, cacheStoragePolicy: .notAllowed)
            client?.urlProtocol(self, didLoad: data)
            client?.urlProtocolDidFinishLoading(self)
        } catch { client?.urlProtocol(self, didFailWithError: error) }
    }
    override func stopLoading() {}
}
private func mockSession(_ handler: @escaping @Sendable (URLRequest) throws -> (Int, Data, [String: String])) -> URLSession {
    MockProtocol.install(handler)
    let config = URLSessionConfiguration.ephemeral
    config.protocolClasses = [MockProtocol.self]
    return URLSession(configuration: config)
}

@Suite(.serialized)
struct MizonAPITests {
    @Test func socketLifecycleAndIdlePlayback() async throws {
        let socket = MizonSocket(mizonApi: MizonApi(), hubURL: URL(string: "https://example.com/mizonHub")!)
        let stream = await socket.events()
        var iterator = stream.makeAsyncIterator()
        if case .stateChanged(.disconnected) = await iterator.next() {} else { Issue.record("Expected initial disconnected state") }
        try await socket.publishMusicPlayback(musicPublicId: UUID(), position: TimeSpan(seconds: -1), isPlaying: false)
        #expect(await socket.isConnected == false)
        await socket.stop()
        if case .stateChanged(.disconnected) = await iterator.next() {} else { Issue.record("Expected stopped state") }
        await socket.dispose()
        _ = await iterator.next()
        #expect(await iterator.next() == nil)
    }
    @Test func modelsMatchWireFormat() throws {
        let data = Data(#"{"Content":{"TITLE":"آهنگ","MusicLanguages":[{"Title":"فارسی"}],"releaseDateTime":"2026-10-26T10:20:30.1234567Z"},"Error":null}"#.utf8)
        let response = try MizonJSON.decoder().decode(BaseApiResponse<MusicResponse>.self, from: data)
        #expect(response.isSuccess)
        #expect(response.content?.title == "آهنگ")
        #expect(response.content?.musicLanguages.first?.title == "فارسی")
        #expect(response.content?.releaseDateTime != nil)
        #expect(response.content?.musicGenres.isEmpty == true)
        #expect(!response.isFromCache)
        let wave = try MizonJSON.decoder().decode(WaveformResponse.self, from: Data(#"{"rms":0.25}"#.utf8))
        #expect(wave.rms == 0.25)
    }
    @Test func timeSpanIsDotNetCompatible() throws {
        for text in ["00:00:00", "01:02:03.1234567", "2.03:04:05.0000001", "-00:00:01.5000000"] {
            let data = Data("\"\(text)\"".utf8)
            let value = try MizonJSON.decoder().decode(TimeSpan.self, from: data)
            let encoded = try MizonJSON.encoder().encode(value)
            #expect(try MizonJSON.decoder().decode(TimeSpan.self, from: encoded) == value)
        }
        #expect(try MizonJSON.decoder().decode(TimeSpan.self, from: Data(#""01:02:03.1234567""#.utf8)).ticks == 37_231_234_567)
        #expect(throws: (any Error).self) { try MizonJSON.decoder().decode(TimeSpan.self, from: Data(#""25:00:00""#.utf8)) }
        #expect(try MizonJSON.decoder().decode(TimeSpan.self, from: Data(#""10675199.02:48:05.4775807""#.utf8)).ticks == Int64.max)
        #expect(try MizonJSON.decoder().decode(TimeSpan.self, from: Data(#""-10675199.02:48:05.4775808""#.utf8)).ticks == Int64.min)
    }
    @Test func getQueryAndDeviceHeaders() async throws {
        let api = MizonApi()
        try await api.setToken("token")
        let id = UUID()
        await api.setDeviceInformation(osVersion: "27.1", deviceIdentifier: "device", deviceModel: "watch", deviceName: "Watch", deviceUsername: "user", platformVersion: id)
        let request = try await api.makeRequest(MusicOperation(MusicRequest(musicPublicId: id)).apiRequest)
        #expect(request.httpMethod == "GET")
        #expect(request.httpBody == nil)
        #expect(request.value(forHTTPHeaderField: "Authorization") == "Bearer token")
        #expect(request.value(forHTTPHeaderField: "Mizon-Device-Model") == "watch")
        let items = URLComponents(url: request.url!, resolvingAgainstBaseURL: false)!.queryItems!
        #expect(items.first?.name == "MusicPublicId")
        #expect(items.first?.value?.lowercased() == id.uuidString.lowercased())
        let special = "فارسی & a+b ? #"
        let descriptor = MizonApiRequest<GlobalSearchRequest, GlobalSearchItemResponse>(httpMethod: .GET, endpoint: URL(string: "https://example.com/Search/Global?existing=yes")!, apiRequest: GlobalSearchRequest(query: special))
        let query = try await api.makeRequest(descriptor)
        #expect(URLComponents(url: query.url!, resolvingAgainstBaseURL: false)?.queryItems?.last?.value == special)
    }
    @Test func postEnvelopeAndCompression() async throws {
        let api = MizonApi()
        var operation = LoginOperation(LoginRequest(username: "ali", password: "secret"))
        operation.apiRequest.compressionMethod = .none
        let request = try await api.makeRequest(operation.apiRequest)
        let json = try JSONSerialization.jsonObject(with: request.httpBody!) as! [String: Any]
        #expect((json["content"] as? [String: Any])?["password"] as? String == "secret")
        #expect(request.value(forHTTPHeaderField: "Authorization") == nil)
        operation.apiRequest.compressionMethod = .gzip
        let gzip = try await api.makeRequest(operation.apiRequest)
        #expect(gzip.httpBody!.prefix(2) == Data([0x1f, 0x8b]))
        #expect(gzip.value(forHTTPHeaderField: "Content-Encoding") == "gzip")
        for method in [CompressionMethod.gzip, .deflate] {
            let source = Data(String(repeating: "سلام world!", count: 100).utf8)
            let compressed = try method.compress(source)
            var z = z_stream()
            #expect(inflateInit2_(&z, method == .gzip ? 31 : -15, ZLIB_VERSION, Int32(MemoryLayout<z_stream>.size)) == Z_OK)
            defer { inflateEnd(&z) }
            var output = Data(count: source.count + 64)
            let status = compressed.withUnsafeBytes { input in
                output.withUnsafeMutableBytes { buffer in
                    z.next_in = UnsafeMutablePointer(mutating: input.bindMemory(to: Bytef.self).baseAddress)
                    z.avail_in = uInt(input.count); z.next_out = buffer.bindMemory(to: Bytef.self).baseAddress
                    z.avail_out = uInt(buffer.count)
                    return inflate(&z, Z_FINISH)
                }
            }
            #expect(status == Z_STREAM_END)
            #expect(output.prefix(Int(z.total_out)) == source)
        }
    }
    @Test func tokenExtractionAndAuthenticatedCache() async throws {
        let session = mockSession { request in
            if request.url!.path.hasSuffix("Login") { return (200, Data(#"{"content":{"accessToken":"abc","refreshToken":"r"}}"#.utf8), [:]) }
            return (200, Data(#"{"content":{"firstName":"Ali","emailAddress":"test@example.com"}}"#.utf8), [:])
        }
        defer { session.invalidateAndCancel() }
        let api = MizonApi(session: session)
        let login = await api.sendRequest(LoginOperation(LoginRequest(password: "secret")))
        #expect(login.isSuccess)
        #expect(await api.getToken() == "abc")
        let first = await api.sendRequest(MeOperation(MeRequest()))
        let second = await api.sendRequest(MeOperation(MeRequest()))
        #expect(!first.isFromCache); #expect(second.isFromCache)
        try await api.setToken("other-user")
        #expect(await api.sendRequest(MeOperation(MeRequest())).isFromCache == false)
        await api.clearToken()
        #expect(await api.sendRequest(MeOperation(MeRequest())).error?.code == 401)
    }
    @Test func errorMapping() async throws {
        let session = mockSession { request in
            switch request.url!.lastPathComponent {
            case "unauthorized": return (401, Data(), [:])
            case "badJSON": return (200, Data("not JSON".utf8), [:])
            case "server": return (500, Data(#"{"error":{"code":12,"title":"Failure"}}"#.utf8), [:])
            case "timeout": throw URLError(.timedOut)
            default: throw URLError(.cancelled)
            }
        }
        defer { session.invalidateAndCancel() }
        let api = MizonApi(session: session)
        for (path, expected) in [("unauthorized", 401), ("badJSON", 103), ("server", 12), ("timeout", 106), ("cancel", 105)] {
            var descriptor = MizonApiRequest<MeRequest, MeResponse>(httpMethod: .GET, endpoint: URL(string: "https://example.com/\(path)")!, apiRequest: MeRequest())
            descriptor.needAuthorized = false
            #expect(await api.sendRequest(descriptor).error?.code == expected)
        }
    }
    @Test func cacheExpirationAndDisabledOperations() async throws {
        let session = mockSession { _ in (200, Data(#"{"content":{}}"#.utf8), [:]) }
        defer { session.invalidateAndCancel() }
        let api = MizonApi(session: session); try await api.setToken("a")
        var descriptor = MeOperation(MeRequest()).apiRequest
        descriptor.maximumClientCacheDuration = 0.01
        #expect(await api.sendRequest(descriptor).isFromCache == false)
        try await Task.sleep(for: .milliseconds(30))
        #expect(await api.sendRequest(descriptor).isFromCache == false)
        let operation = MusicCommentCreateOperation(MusicCommentCreateRequest(text: "comment"))
        #expect(await api.sendRequest(operation).isFromCache == false)
        #expect(await api.sendRequest(operation).isFromCache == false)
    }
    @Test func searchStreamsNDJSON() async throws {
        let session = mockSession { _ in
            (200, Data("{\"itemType\":\"Music\",\"title\":\"اول\"}\n\n{\"itemType\":\"Client\",\"firstName\":\"Ali\"}\n".utf8), [:])
        }
        defer { session.invalidateAndCancel() }
        let api = MizonApi(session: session); try await api.setToken("a")
        var items: [GlobalSearchItemResponse] = []
        for try await item in await api.sendStreamRequest(GlobalSearchOperation(GlobalSearchRequest(query: "a"))) { items.append(item) }
        #expect(items.count == 2); #expect(items.first?.title == "اول")
    }
    @Test func downloaderResumesAndPromotesBeforeFinalChunk() async throws {
        let root = FileManager.default.temporaryDirectory.appendingPathComponent(UUID().uuidString)
        try FileManager.default.createDirectory(at: root, withIntermediateDirectories: true)
        defer { try? FileManager.default.removeItem(at: root) }
        let source = root.appendingPathComponent("input.bin")
        let bytes = Data((0..<100).map { UInt8($0) }); try bytes.write(to: source)
        let downloader = MediaDownloader(cacheRoot: root.appendingPathComponent("cache"))
        let info = MediaResponse(chunkSize: 17, fileHash: "hash", fileName: "sample.bin", fileSize: 100, category: "music")
        let final = try await downloader.getCachedFilePath(info)
        try bytes.prefix(23).write(to: final.appendingPathExtension("part"))
        var last: DownloadChunk?
        for try await chunk in await downloader.download(info, storageURL: source) {
            if chunk.isLastChunk { #expect(FileManager.default.fileExists(atPath: chunk.path.path)) }
            last = chunk
        }
        #expect(last?.totalDownloaded == 100); #expect(last?.path == final)
        #expect(try Data(contentsOf: final) == bytes)
        #expect(try await downloader.isCached(info))
        let cached = try await downloader.downloadToCache(info, storageURL: source)
        #expect(cached == final)
    }
    @Test func downloaderValidatesRanges() async throws {
        let bytes = Data((0..<40).map { UInt8($0) })
        let session = mockSession { request in
            let range = request.value(forHTTPHeaderField: "Range")!.dropFirst(6).split(separator: "-").map { Int($0)! }
            let data = bytes.subdata(in: range[0]..<(range[1] + 1))
            return (206, data, ["Content-Range": "bytes \(range[0])-\(range[1])/40"])
        }
        defer { session.invalidateAndCancel() }
        let root = FileManager.default.temporaryDirectory.appendingPathComponent(UUID().uuidString)
        defer { try? FileManager.default.removeItem(at: root) }
        let downloader = MediaDownloader(session: session, cacheRoot: root)
        let info = MediaResponse(chunkSize: 13, fileHash: "hash", fileName: "file", fileSize: 40)
        let path = try await downloader.downloadToCache(info, storageURL: URL(string: "https://example.com/media")!)
        #expect(try Data(contentsOf: path) == bytes)
    }
    @Test func downloaderCancellationAndPathSafety() async throws {
        let root = FileManager.default.temporaryDirectory.appendingPathComponent(UUID().uuidString)
        defer { try? FileManager.default.removeItem(at: root) }
        let downloader = MediaDownloader(cacheRoot: root)
        do { _ = try await downloader.getCachedFilePath(MediaResponse(fileHash: "../escape", fileName: "file")); Issue.record("Expected invalid path") }
        catch { #expect((error as? BaseApiError)?.code == 102) }
        let control = DownloadSession(); await control.cancel()
        do {
            _ = try await downloader.downloadToCache(MediaResponse(chunkSize: 1, fileName: "file", fileSize: 2), storageURL: URL(string: "https://example.com/file")!, session: control)
            Issue.record("Expected cancellation")
        } catch { #expect(error is CancellationError) }
    }
    @Test func officialSignalRPresenceAndJWT() throws {
        let id = UUID()
        let text = "{\"sub\":\"\(id)\"}"
        let payload = Data(text.utf8).base64EncodedString().replacingOccurrences(of: "=", with: "").replacingOccurrences(of: "+", with: "-").replacingOccurrences(of: "/", with: "_")
        #expect(MizonSocket.clientPublicId(from: "a.\(payload).signature") == id)
        #expect(MizonSocket.clientPublicId(from: "invalid") == nil)
        let json = Data("{\"clientPublicId\":\"\(id)\",\"updatedAtUtc\":\"2026-10-26T12:00:00.1234567Z\"}".utf8)
        let listener = try JSONDecoder().decode(MusicListenerPresence.self, from: json)
        #expect(listener.clientPublicId == id)
        let encoded = try JSONEncoder().encode(listener)
        #expect(try abs(JSONDecoder().decode(MusicListenerPresence.self, from: encoded).updatedAtUtc.timeIntervalSince1970 - listener.updatedAtUtc.timeIntervalSince1970) < 0.001)
    }
}
