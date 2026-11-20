import Foundation
import MizonAPI

public struct LoginOperation: APIOperation {
    public var apiRequest: MizonApiRequest<LoginRequest, LoginResponse>

    public init(_ request: LoginRequest, endpoints: Endpoints = Endpoints(), updateToken: Bool = true) {
        apiRequest = MizonApiRequest(httpMethod: .POST, endpoint: endpoints.clients.login, apiRequest: request)
        apiRequest.clientCacheStrategy = .disabled
        apiRequest.needAuthorized = false
        if updateToken { apiRequest.propertyForToken = { $0.accessToken } }
    }
}
