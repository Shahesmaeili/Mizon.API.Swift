import MizonAPI

public struct PersonProfileOperation: APIOperation {
    public var apiRequest: MizonApiRequest<PersonProfileRequest, PersonProfileResponse>

    public init(_ request: PersonProfileRequest, endpoints: Endpoints = Endpoints()) {
        apiRequest = MizonApiRequest(httpMethod: .GET, endpoint: endpoints.persons.personProfile, apiRequest: request)
        apiRequest.clientCacheStrategy = .disabled
    }
}
