import MizonAPI

public struct ClientMoodTypesOperation: APIOperation {
    public var apiRequest: MizonApiRequest<ClientMoodTypesRequest, ClientMoodTypesResponse>

    public init(_ request: ClientMoodTypesRequest, endpoints: Endpoints = Endpoints()) {
        apiRequest = MizonApiRequest(httpMethod: .GET, endpoint: endpoints.clients.clientMoodTypes, apiRequest: request)
        apiRequest.clientCacheStrategy = .disabled
    }
}
