import Foundation
public struct MizonApiRequest<Request: IApiRequest, Response: IApiResponse>: Sendable {
    public var baseApiRequest: BaseApiRequest<Request>
    public var needAuthorized = true
    public var propertyForToken: (@Sendable (Response) -> String)?
    public var clientCacheStrategy: ClientCacheStrategy = .enabledOnDuplicateRequest
    public var maximumClientCacheDuration: TimeInterval = 300
    public var callTimeoutDuration: TimeInterval = 10
    public var compressionMethod: CompressionMethod = .gzip
    public var httpMethod: HttpMethod
    public var endpoint: URL
    public init(httpMethod: HttpMethod, endpoint: URL, apiRequest: Request) {
        self.httpMethod = httpMethod; self.endpoint = endpoint
        baseApiRequest = BaseApiRequest(content: apiRequest)
    }
}
public protocol APIOperation: Sendable {
    associatedtype Request: IApiRequest
    associatedtype Response: IApiResponse
    var apiRequest: MizonApiRequest<Request, Response> { get }
}
