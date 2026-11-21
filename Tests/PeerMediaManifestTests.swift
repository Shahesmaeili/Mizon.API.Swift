import CryptoKit
import Foundation
import MizonAPI
import MizonAPIClient
import Testing

@Suite(.serialized)
struct PeerMediaManifestTests {
    @Test func manifestValidatesWindowsLayoutAndIndexes() throws {
        let fixture = Fixture()
        let manifest = try #require(fixture.manifest)
        #expect(manifest.rawFileHash == Data(SHA256.hash(data: fixture.bytes)))
        #expect(manifest.fileHash == fixture.info.fileHash.lowercased())
        #expect(manifest.pieceCount == 3)
        #expect(manifest.range(for: 0) == 0...3)
        #expect(manifest.range(for: 2) == 8...9)
        #expect(manifest.pieceLength(at: 2) == 2)
        #expect(manifest.digest(at: -1) == nil)
        #expect(manifest.range(for: 3) == nil)
        #expect(manifest.verify(Data([8, 9]), at: 2))
        #expect(!manifest.verify(Data([8, 7]), at: 2))
        #expect(!manifest.verify(Data([8, 9, 10]), at: 2))
        #expect(VerifiedMediaManifest(fileHash: fixture.info.fileHash, fileSize: 10, chunkSize: 4,
                                      pieceSha256: fixture.digests.dropLast()) == nil)
        #expect(VerifiedMediaManifest(fileHash: fixture.info.fileHash, fileSize: Int64.max, chunkSize: 4,
                                      pieceSha256: fixture.digests) == nil)
        #expect(VerifiedMediaManifest(fileHash: String(repeating: "g", count: 64), fileSize: 10,
                                      chunkSize: 4, pieceSha256: fixture.digests) == nil)
    }

    @Test func usesSameOriginAPIForManifestAndManagedPiece() async throws {
        let fixture = Fixture()
        defer { fixture.removeCache() }
        let http = mockSession { request in
            #expect(request.url?.host == "mizon.example")
            #expect(request.url?.port == 5128)
            #expect(request.value(forHTTPHeaderField: "Authorization") == "Bearer managed-token")
            #expect(request.assumesHTTP3Capable)
            #expect(request.mediaPublicID == fixture.info.mediaPublicId)
            switch request.url?.path {
            case "/api/Medias/PeerManifest":
                return (200, fixture.manifestEnvelope, [:])
            case "/api/Medias/MediaContent":
                #expect(request.value(forHTTPHeaderField: "Range") == "bytes=8-9")
                return (206, Data([8, 9]), ["Content-Range": "bytes 8-9/10"])
            default:
                Issue.record("Unexpected media endpoint")
                return (404, Data(), [:])
            }
        }
        defer { http.invalidateAndCancel() }
        let api = MizonApi(session: http)
        try await api.setToken("managed-token")
        let downloader = MediaDownloader(cacheRoot: fixture.cacheRoot)
        let manifest = try #require(await downloader.peerManifest(for: fixture.info, api: api, endpoints: fixture.endpoints))
        #expect(manifest == fixture.manifest)
        let piece = try await downloader.readOriginPiece(for: fixture.info, manifest: manifest, index: 2, api: api, endpoints: fixture.endpoints)
        #expect(piece == Data([8, 9]))
        #expect(try await !downloader.isCached(fixture.info))
    }

    @Test func unavailableManifestFallsBackAndRedirectIsRejected() async throws {
        let fixture = Fixture()
        defer { fixture.removeCache() }
        let api = MizonApi(session: mockSession { _ in (404, Data("invalid body".utf8), [:]) })
        try await api.setToken("fixture-token")
        let downloader = MediaDownloader(cacheRoot: fixture.cacheRoot)
        #expect(try await downloader.peerManifest(for: fixture.info, api: api, endpoints: fixture.endpoints) == nil)

        let forbidden = MizonApi(session: mockSession { _ in (403, Data(), [:]) })
        try await forbidden.setToken("fixture-token")
        #expect(try await downloader.peerManifest(for: fixture.info, api: forbidden, endpoints: fixture.endpoints) == nil)

        let redirected = MizonApi(session: mockSession { request in
            #expect(request.url?.host == "mizon.example")
            return (307, Data(), ["Location": "https://external.example/manifest"])
        })
        try await redirected.setToken("fixture-token")
        await #expect(throws: BaseApiError(code: 307, title: "Media manifest request failed")) {
            try await downloader.peerManifest(for: fixture.info, api: redirected, endpoints: fixture.endpoints)
        }
    }

    @Test func verifiedHTTPSPiecesStripInjectedCredentialsAndRejectCorruptionOrLengthMismatch() async throws {
        let fixture = Fixture(storagePath: "https://storage.example/asset")
        defer { fixture.removeCache() }
        let http = mockSession(defaultHeaders: ["Authorization": "Bearer injected-secret", "Cookie": "secret=1"]) { request in
            #expect(request.url?.host == "storage.example")
            #expect(request.value(forHTTPHeaderField: "Authorization") == nil)
            #expect(request.value(forHTTPHeaderField: "Cookie") == nil)
            #expect(!request.httpShouldHandleCookies)
            let range = request.value(forHTTPHeaderField: "Range")
            switch range {
            case "bytes=0-3": return (206, Data([0, 1, 2, 3]), ["Content-Range": "bytes 0-3/10"])
            case "bytes=4-7": return (206, Data([4, 5, 6, 0]), ["Content-Range": "bytes 4-7/10"])
            case "bytes=8-9": return (206, Data([8, 9, 10]), ["Content-Range": "bytes 8-9/10"])
            default:
                Issue.record("More than one piece or an invalid index was requested")
                return (400, Data(), [:])
            }
        }
        defer { http.invalidateAndCancel() }
        let api = MizonApi()
        try await api.setToken("api-token")
        let downloader = MediaDownloader(session: http, cacheRoot: fixture.cacheRoot)
        let manifest = try #require(fixture.manifest)
        #expect(try await downloader.readOriginPiece(for: fixture.info, manifest: manifest, index: 0, api: api, endpoints: fixture.endpoints) ==
                Data([0, 1, 2, 3]))
        await #expect(throws: BaseApiError(code: 102, title: "Media piece verification failed")) {
            try await downloader.readOriginPiece(for: fixture.info, manifest: manifest, index: 1, api: api, endpoints: fixture.endpoints)
        }
        await #expect(throws: BaseApiError(code: 102, title: "Oversized media response")) {
            try await downloader.readOriginPiece(for: fixture.info, manifest: manifest, index: 2, api: api, endpoints: fixture.endpoints)
        }
        await #expect(throws: BaseApiError(code: 102, title: "Invalid verified media piece")) {
            try await downloader.readOriginPiece(for: fixture.info, manifest: manifest, index: -1, api: api, endpoints: fixture.endpoints)
        }
    }

    private struct Fixture: Sendable {
        let bytes: Data
        let digests: Data
        let cacheRoot = FileManager.default.temporaryDirectory.appendingPathComponent(UUID().uuidString)
        let endpoints = Endpoints(baseURL: URL(string: "https://mizon.example:5128/api")!)
        let info: MediaResponse

        init(storagePath: String = "file:///C:/Mizon/Shared/fixture.bin") {
            let bytes = Data(0..<10)
            self.bytes = bytes
            let hash = SHA256.hash(data: bytes).map { String(format: "%02X", $0) }.joined()
            info = MediaResponse(mediaPublicId: UUID(), totalChunks: 3, chunkSize: 4, fileHash: hash,
                                 fileName: "fixture.bin", fileSize: 10, storagePath: storagePath)
            digests = Data(stride(from: 0, to: bytes.count, by: 4).flatMap { offset in
                Array(SHA256.hash(data: bytes[offset..<min(offset + 4, bytes.count)]))
            })
        }

        var manifest: VerifiedMediaManifest? {
            VerifiedMediaManifest(fileHash: info.fileHash, fileSize: info.fileSize, chunkSize: info.chunkSize, pieceSha256: digests)
        }

        var manifestEnvelope: Data {
            Data("""
                {"Content":{"FileHash":"\(info.fileHash)","FileSize":10,"ChunkSize":4,"PieceSha256":"\(digests.base64EncodedString())"}}
                """.utf8)
        }

        func removeCache() { try? FileManager.default.removeItem(at: cacheRoot) }
    }

    private func mockSession(defaultHeaders: [String: String] = [:],
                             handler: @escaping @Sendable (URLRequest) -> (Int, Data, [String: String])) -> URLSession {
        PeerMediaProtocol.install(handler)
        let configuration = URLSessionConfiguration.ephemeral
        configuration.protocolClasses = [PeerMediaProtocol.self]
        configuration.httpAdditionalHeaders = defaultHeaders
        return URLSession(configuration: configuration)
    }
}

private extension URLRequest {
    var mediaPublicID: UUID? {
        guard let url, let value = URLComponents(url: url, resolvingAgainstBaseURL: false)?.queryItems?
            .first(where: { $0.name == "MediaPublicId" })?.value else { return nil }
        return UUID(uuidString: value)
    }
}

private final class PeerMediaProtocol: URLProtocol, @unchecked Sendable {
    private static let lock = NSLock()
    nonisolated(unsafe) private static var handler: (@Sendable (URLRequest) -> (Int, Data, [String: String]))?

    static func install(_ callback: @escaping @Sendable (URLRequest) -> (Int, Data, [String: String])) {
        lock.withLock { handler = callback }
    }

    override class func canInit(with request: URLRequest) -> Bool { true }
    override class func canonicalRequest(for request: URLRequest) -> URLRequest { request }

    override func startLoading() {
        guard let handler = Self.lock.withLock({ Self.handler }), let url = request.url else { return }
        let (status, data, headers) = handler(request)
        guard let response = HTTPURLResponse(url: url, statusCode: status, httpVersion: "HTTP/1.1", headerFields: headers) else { return }
        client?.urlProtocol(self, didReceive: response, cacheStoragePolicy: .notAllowed)
        client?.urlProtocol(self, didLoad: data)
        client?.urlProtocolDidFinishLoading(self)
    }

    override func stopLoading() {}
}
