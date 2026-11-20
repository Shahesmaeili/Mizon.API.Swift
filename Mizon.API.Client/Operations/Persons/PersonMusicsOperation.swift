import MizonAPI

public struct PersonMusicsOperation: APIOperation {
    public var apiRequest: MizonApiRequest<PersonMusicsRequest, PersonMusicsResponse>

    public init(_ request: PersonMusicsRequest, endpoints: Endpoints = Endpoints()) {
        apiRequest = MizonApiRequest(httpMethod: .GET, endpoint: endpoints.persons.personMusics, apiRequest: request)
        apiRequest.clientCacheStrategy = .disabled
    }
}
