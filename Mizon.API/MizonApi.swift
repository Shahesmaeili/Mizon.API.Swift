import Foundation
import CryptoKit

/// Thread-safe client. Inject a URLSession for tests or app-specific networking policy.
public actor MizonApi {
    private let session: URLSession
    private var token: String?
    private var informationHeaders: [String: String] = [:]
    private struct CacheEntry { var data: Data; var expires: Date }
    private var cache: [String: CacheEntry] = [:]
    private var credentialGeneration: UInt64 = 0
    public init(session: URLSession = .shared) { self.session = session }
    public func setToken(_ token: String) throws {
        guard !token.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
            throw BaseApiError(code: 401, title: "Token cannot be empty")
        }
        self.token = token; cache.removeAll(); credentialGeneration &+= 1
    }
    public func getToken() -> String? { token }
    public func clearToken() { token = nil; cache.removeAll(); credentialGeneration &+= 1 }
    public func clearCache() { cache.removeAll() }
    public func setDeviceInformation(osVersion: String, deviceIdentifier: String, deviceModel: String,
                                     deviceName: String, deviceUsername: String, platformVersion: UUID) {
        informationHeaders = ["Mizon-OS-Version": osVersion, "Mizon-Device-Identifier": deviceIdentifier,
            "Mizon-Device-Model": deviceModel, "Mizon-Device-Name": deviceName,
            "Mizon-Device-Username": deviceUsername, "Mizon-Platform-Version": platformVersion.uuidString.lowercased()]
        cache.removeAll()
    }
    public func sendRequest<Operation: APIOperation>(_ operation: Operation) async -> BaseApiResponse<Operation.Response> {
        await sendRequest(operation.apiRequest)
    }
    public func sendRequest<Request, Response>(_ descriptor: MizonApiRequest<Request, Response>) async -> BaseApiResponse<Response> {
        do {
            try Task.checkCancellation()
            let request = try makeRequest(descriptor)
            let generation = credentialGeneration
            let key = cacheKey(request)
            cache = cache.filter { $0.value.expires > Date() }
            if descriptor.clientCacheStrategy != .disabled, let entry = cache[key] {
                var response = try MizonJSON.decoder().decode(BaseApiResponse<Response>.self, from: entry.data)
                response.isFromCache = true
                return response
            }
            let (data, rawResponse) = try await withRequestDeadline(seconds: descriptor.callTimeoutDuration) { [session] in
                try await session.data(for: request)
            }
            try Task.checkCancellation()
            guard let http = rawResponse as? HTTPURLResponse else { throw BaseApiError(code: 107, title: "Invalid HTTP response") }
            if http.statusCode == 401 { return BaseApiResponse(error: BaseApiError(code: 401, title: "Unauthorized")) }
            let result = try MizonJSON.decoder().decode(BaseApiResponse<Response>.self, from: data)
            if !(200..<300).contains(http.statusCode), result.error == nil {
                return BaseApiResponse(error: BaseApiError(code: http.statusCode, title: "HTTP Error"))
            }
            if result.isSuccess, generation == credentialGeneration {
                if let extract = descriptor.propertyForToken, let content = result.content {
                    try setToken(extract(content))
                }
                if descriptor.clientCacheStrategy != .disabled, descriptor.maximumClientCacheDuration > 0 {
                    // Token-changing responses must never be shared through the response cache.
                    if descriptor.propertyForToken == nil {
                        cache[key] = CacheEntry(data: data, expires: Date().addingTimeInterval(descriptor.maximumClientCacheDuration))
                    }
                }
            }
            return result
        } catch {
            return BaseApiResponse(error: Self.mapError(error))
        }
    }
    public func makeRequest<Request, Response>(_ descriptor: MizonApiRequest<Request, Response>) throws -> URLRequest {
        var request = try authorizedRequest(endpoint: descriptor.endpoint, timeout: descriptor.callTimeoutDuration,
                                            needAuthorized: descriptor.needAuthorized)
        request.httpMethod = descriptor.httpMethod.rawValue
        if descriptor.httpMethod == .GET || descriptor.httpMethod == .HEAD {
            request.url = try queryURL(descriptor.endpoint, content: descriptor.baseApiRequest.content)
        } else {
            let data = try MizonJSON.encoder().encode(descriptor.baseApiRequest)
            request.httpBody = try descriptor.compressionMethod.compress(data)
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            switch descriptor.compressionMethod {
            case .gzip: request.setValue("gzip", forHTTPHeaderField: "Content-Encoding")
            case .deflate: request.setValue("deflate", forHTTPHeaderField: "Content-Encoding")
            case .none: break
            }
        }
        return request
    }
    private func authorizedRequest(endpoint: URL, timeout: TimeInterval, needAuthorized: Bool) throws -> URLRequest {
        guard timeout > 0, timeout.isFinite else { throw BaseApiError(code: 108, title: "Invalid timeout") }
        var request = URLRequest(url: endpoint, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: timeout)
        if needAuthorized {
            guard let token, !token.isEmpty else { throw BaseApiError(code: 401, title: "This method needs authorization") }
            request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        }
        for (key, value) in informationHeaders { request.setValue(value, forHTTPHeaderField: key) }
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        return request
    }
    private func queryURL<Request: IApiRequest>(_ url: URL, content: Request?) throws -> URL {
        guard let content else { return url }
        let items: [URLQueryItem]
        if let custom = content as? any APIQueryRequest { items = try custom.queryItems() }
        else {
            let data = try MizonJSON.encoder().encode(content)
            guard let object = try JSONSerialization.jsonObject(with: data) as? [String: Any] else { return url }
            items = object.keys.sorted().compactMap { key in
                guard let value = object[key], !(value is NSNull) else { return nil }
                let rendered: String
                if let number = value as? NSNumber, CFGetTypeID(number) == CFBooleanGetTypeID() {
                    rendered = number.boolValue ? "True" : "False"
                } else { rendered = String(describing: value) }
                // The .NET client uses PascalCase CLR property names in its query strings.
                return URLQueryItem(name: key.prefix(1).uppercased() + key.dropFirst(), value: rendered)
            }
        }
        var components = URLComponents(url: url, resolvingAgainstBaseURL: false)!
        // ASP.NET query parsing treats a literal '+' as a space. URLQueryItem alone
        // leaves '+' unescaped, unlike Uri.EscapeDataString in the .NET client.
        let allowed = CharacterSet(charactersIn: "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789-._~")
        let encoded = items.map { item in
            let name = item.name.addingPercentEncoding(withAllowedCharacters: allowed)!
            return name + (item.value.map { "=" + $0.addingPercentEncoding(withAllowedCharacters: allowed)! } ?? "")
        }.joined(separator: "&")
        if !encoded.isEmpty {
            components.percentEncodedQuery = [components.percentEncodedQuery, encoded].compactMap { $0 }.filter { !$0.isEmpty }.joined(separator: "&")
        }
        return components.url!
    }
    private func cacheKey(_ request: URLRequest) -> String {
        let headers = (request.allHTTPHeaderFields ?? [:]).sorted { $0.key < $1.key }.map { "\($0.key):\($0.value)" }.joined(separator: "\n")
        let text = "\(request.httpMethod ?? "GET")|\(request.url!.absoluteString)|\(headers)|\(credentialGeneration)"
        var data = Data(text.utf8); data.append(request.httpBody ?? Data())
        return SHA256.hash(data: data).map { String(format: "%02x", $0) }.joined()
    }
    public func sendStreamRequest<Operation: APIStreamOperation>(_ operation: Operation) -> AsyncThrowingStream<Operation.Response, any Error> {
        sendStreamRequest(operation.apiRequest)
    }
    public func sendStreamRequest<Request, Response>(_ descriptor: MizonApiStreamRequest<Request, Response>) -> AsyncThrowingStream<Response, any Error> {
        let (stream, continuation) = AsyncThrowingStream<Response, any Error>.makeStream()
        let worker = Task {
            do {
                guard descriptor.httpMethod == .GET else { throw BaseApiError(code: 108, title: "Stream requests require GET") }
                var request = try self.authorizedRequest(endpoint: descriptor.endpoint, timeout: descriptor.callTimeoutDuration, needAuthorized: descriptor.needAuthorized)
                request.url = try self.queryURL(descriptor.endpoint, content: descriptor.baseApiRequest.content)
                let streamRequest = request
                try await withRequestDeadline(seconds: descriptor.callTimeoutDuration) { [session] in
                    let (bytes, response) = try await session.bytes(for: streamRequest)
                    guard let http = response as? HTTPURLResponse, (200..<300).contains(http.statusCode) else {
                        throw BaseApiError(code: (response as? HTTPURLResponse)?.statusCode ?? 107, title: "Stream HTTP error")
                    }
                    for try await line in bytes.lines {
                        try Task.checkCancellation()
                        guard !line.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else { continue }
                        continuation.yield(try MizonJSON.decoder().decode(Response.self, from: Data(line.utf8)))
                    }
                }
                continuation.finish()
            } catch { continuation.finish(throwing: error) }
        }
        continuation.onTermination = { @Sendable _ in worker.cancel() }
        return stream
    }
    private static func mapError(_ error: any Error) -> BaseApiError {
        if let api = error as? BaseApiError { return api }
        if error is CancellationError || (error as? URLError)?.code == .cancelled { return BaseApiError(code: 105, title: "Cancelled by User") }
        if error is DecodingError { return BaseApiError(code: 103, title: "Invalid JSON", details: error.localizedDescription) }
        if let url = error as? URLError {
            return BaseApiError(code: url.code == .timedOut ? 106 : 107, title: url.code == .timedOut ? "Request Timeout" : "HTTP Error", details: url.localizedDescription)
        }
        return BaseApiError(code: 108, title: "Unexpected Error", details: error.localizedDescription)
    }
}
