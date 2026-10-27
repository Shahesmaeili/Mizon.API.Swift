import Foundation
import MizonAPI

public struct StoryCreateOperation: APIOperation {
    public var apiRequest: MizonApiRequest<StoryCreateRequest, StoryResponse>

    public init(_ request: StoryCreateRequest, endpoints: Endpoints = Endpoints()) {
        apiRequest = MizonApiRequest(httpMethod: .POST, endpoint: endpoints.url("Stories/StoryCreate"), apiRequest: request)
        apiRequest.maximumClientCacheDuration = 300
        apiRequest.clientCacheStrategy = .disabled
    }
}
