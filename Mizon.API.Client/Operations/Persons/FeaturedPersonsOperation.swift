import MizonAPI

public struct FeaturedPersonsOperation: APIOperation {
    public var apiRequest: MizonApiRequest<FeaturedPersonsRequest, FeaturedPersonsResponse>

    public init(_ request: FeaturedPersonsRequest, endpoints: Endpoints = Endpoints()) {
        apiRequest = MizonApiRequest(httpMethod: .GET, endpoint: endpoints.persons.featuredPersons, apiRequest: request)
        apiRequest.clientCacheStrategy = .disabled
    }
}
