import Foundation
import MizonAPI

public struct StoryLikeOperation: APIOperation {
    public var apiRequest: MizonApiRequest<StoryLikeRequest, StoryResponse>

    public init(_ request: StoryLikeRequest, endpoints: Endpoints = Endpoints()) {
        apiRequest = MizonApiRequest(httpMethod: .POST, endpoint: endpoints.url("Stories/StoryLike"), apiRequest: request)
        apiRequest.maximumClientCacheDuration = 300
        apiRequest.clientCacheStrategy = .disabled
    }
}
