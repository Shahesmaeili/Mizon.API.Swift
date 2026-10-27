import Foundation
import MizonAPI

public struct MusicCommentsOperation: APIOperation {
    public var apiRequest: MizonApiRequest<MusicCommentsRequest, MusicCommentsResponse>

    public init(_ request: MusicCommentsRequest, endpoints: Endpoints = Endpoints()) {
        apiRequest = MizonApiRequest(httpMethod: .GET, endpoint: endpoints.url("Musics/MusicComments"), apiRequest: request)
        apiRequest.maximumClientCacheDuration = 300
        apiRequest.clientCacheStrategy = .disabled
    }
}
