import MizonAPI

public struct PersonFollowOperation: APIOperation {
    public var apiRequest: MizonApiRequest<PersonFollowRequest, PersonFollowResponse>

    public init(_ request: PersonFollowRequest, endpoints: Endpoints = Endpoints()) {
        apiRequest = MizonApiRequest(httpMethod: .POST, endpoint: endpoints.persons.personFollow, apiRequest: request)
        apiRequest.clientCacheStrategy = .disabled
    }
}
