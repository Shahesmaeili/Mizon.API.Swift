import Foundation
import MizonAPI

public struct LogoutOperation: APIOperation {
    public var apiRequest: MizonApiRequest<LogoutRequest, LogoutResponse>

    public init(_ request: LogoutRequest, endpoints: Endpoints = Endpoints()) {
        apiRequest = MizonApiRequest(httpMethod: .POST, endpoint: endpoints.clients.logout, apiRequest: request)
        apiRequest.clientCacheStrategy = .disabled
    }
}
