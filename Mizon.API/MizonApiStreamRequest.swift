import Foundation
public struct MizonApiStreamRequest<Request: IApiRequest, Response: IApiResponse>: Sendable {
    public var baseApiRequest: BaseApiRequest<Request>
    public var needAuthorized = true
    public var callTimeoutDuration: TimeInterval = 10
    public var httpMethod: HttpMethod
    public var endpoint: URL
    public init(httpMethod: HttpMethod, endpoint: URL, apiRequest: Request) {
        self.httpMethod = httpMethod; self.endpoint = endpoint
        baseApiRequest = BaseApiRequest(content: apiRequest)
    }
}
public protocol APIStreamOperation: Sendable {
    associatedtype Request: IApiRequest
    associatedtype Response: IApiResponse
    var apiRequest: MizonApiStreamRequest<Request, Response> { get }
}
