import MizonAPI

public struct ClientMoodOperation: APIOperation {
    public var apiRequest: MizonApiRequest<ClientMoodRequest, ClientMoodResponse>

    public init(_ request: ClientMoodRequest, endpoints: Endpoints = Endpoints()) {
        apiRequest = MizonApiRequest(httpMethod: .POST, endpoint: endpoints.clients.clientMood, apiRequest: request)
        apiRequest.clientCacheStrategy = .disabled
    }
}
