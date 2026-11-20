import MizonAPI

public struct RegisterOperation: APIOperation {
    public var apiRequest: MizonApiRequest<RegisterRequest, RegisterResponse>

    public init(_ request: RegisterRequest, endpoints: Endpoints = Endpoints(), updateToken: Bool = true) {
        apiRequest = MizonApiRequest(httpMethod: .POST, endpoint: endpoints.clients.register, apiRequest: request)
        apiRequest.needAuthorized = false
        apiRequest.clientCacheStrategy = .disabled
        if updateToken {
            apiRequest.propertyForToken = { $0.accessToken }
        }
    }
}
