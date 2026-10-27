import Foundation
import MizonAPI

public struct StoryDetailsOperation: APIOperation {
    public var apiRequest: MizonApiRequest<StoryRequest, StoryResponse>

    public init(_ request: StoryRequest, endpoints: Endpoints = Endpoints()) {
        apiRequest = MizonApiRequest(httpMethod: .GET, endpoint: endpoints.url("Stories/StoryDetails"), apiRequest: request)
        apiRequest.maximumClientCacheDuration = 300
        apiRequest.clientCacheStrategy = .disabled
    }
}
