import Foundation
import MizonAPI

public struct LogoutOperation: APIOperation {
    public var apiRequest: MizonApiRequest<LogoutRequest, LogoutResponse>

    public init(_ request: LogoutRequest, endpoints: Endpoints = Endpoints()) {
        apiRequest = MizonApiRequest(httpMethod: .POST, endpoint: endpoints.url("Clients/Logout"), apiRequest: request)
        apiRequest.maximumClientCacheDuration = 5
    }
}
