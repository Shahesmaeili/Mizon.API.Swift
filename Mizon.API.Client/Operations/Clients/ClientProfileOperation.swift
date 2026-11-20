import MizonAPI

public struct ClientProfileOperation: APIOperation {
    public var apiRequest: MizonApiRequest<ClientProfileRequest, ClientProfileResponse>

    public init(_ request: ClientProfileRequest, endpoints: Endpoints = Endpoints()) {
        apiRequest = MizonApiRequest(httpMethod: .GET, endpoint: endpoints.clients.clientProfile, apiRequest: request)
        apiRequest.clientCacheStrategy = .disabled
    }
}
