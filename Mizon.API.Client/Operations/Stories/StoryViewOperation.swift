import Foundation
import MizonAPI

public struct StoryViewOperation: APIOperation {
    public var apiRequest: MizonApiRequest<StoryRequest, StoryResponse>

    public init(_ request: StoryRequest, endpoints: Endpoints = Endpoints()) {
        apiRequest = MizonApiRequest(httpMethod: .POST, endpoint: endpoints.url("Stories/StoryView"), apiRequest: request)
        apiRequest.maximumClientCacheDuration = 300
        apiRequest.clientCacheStrategy = .disabled
    }
}
