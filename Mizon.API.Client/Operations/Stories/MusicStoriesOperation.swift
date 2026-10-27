import Foundation
import MizonAPI

public struct MusicStoriesOperation: APIOperation {
    public var apiRequest: MizonApiRequest<MusicStoriesRequest, StoriesResponse>

    public init(_ request: MusicStoriesRequest, endpoints: Endpoints = Endpoints()) {
        apiRequest = MizonApiRequest(httpMethod: .GET, endpoint: endpoints.url("Stories/MusicStories"), apiRequest: request)
        apiRequest.maximumClientCacheDuration = 10
    }
}
