import Foundation
import MizonAPI

public struct StoriesOperation: APIOperation {
    public var apiRequest: MizonApiRequest<StoriesRequest, StoriesResponse>

    public init(_ request: StoriesRequest = StoriesRequest(), endpoints: Endpoints = Endpoints()) {
        apiRequest = MizonApiRequest(httpMethod: .GET, endpoint: endpoints.url("Stories/Stories"), apiRequest: request)
        apiRequest.maximumClientCacheDuration = 300
    }
}
