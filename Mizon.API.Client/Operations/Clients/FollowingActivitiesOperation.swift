import MizonAPI

public struct FollowingActivitiesOperation: APIOperation {
    public var apiRequest: MizonApiRequest<FollowingActivitiesRequest, FollowingActivitiesResponse>

    public init(_ request: FollowingActivitiesRequest, endpoints: Endpoints = Endpoints()) {
        apiRequest = MizonApiRequest(httpMethod: .POST, endpoint: endpoints.clients.followingActivities, apiRequest: request)
        apiRequest.clientCacheStrategy = .disabled
    }
}
