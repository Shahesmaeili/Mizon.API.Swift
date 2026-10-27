import Foundation
import MizonAPI

public struct LoginOperation: APIOperation {
    public var apiRequest: MizonApiRequest<LoginRequest, LoginResponse>

    public init(_ request: LoginRequest, endpoints: Endpoints = Endpoints()) {
        apiRequest = MizonApiRequest(httpMethod: .POST, endpoint: endpoints.url("Clients/Login"), apiRequest: request)
        apiRequest.maximumClientCacheDuration = 5
        apiRequest.needAuthorized = false
        apiRequest.propertyForToken = { $0.accessToken }
    }
}
