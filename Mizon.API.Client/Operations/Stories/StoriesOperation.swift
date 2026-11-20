import Foundation
import MizonAPI

public struct StoriesOperation: APIOperation {
    public var apiRequest: MizonApiRequest<StoriesRequest, StoriesResponse>

    public init(_ request: StoriesRequest = StoriesRequest(), endpoints: Endpoints = Endpoints()) {
        apiRequest = MizonApiRequest(httpMethod: .GET, endpoint: endpoints.stories.list, apiRequest: request)
        apiRequest.clientCacheStrategy = .disabled
        apiRequest.maximumClientCacheDuration = 300
    }
}
