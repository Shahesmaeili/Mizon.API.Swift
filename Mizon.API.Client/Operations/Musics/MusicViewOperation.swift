import Foundation
import MizonAPI

public struct MusicViewOperation: APIOperation {
    public var apiRequest: MizonApiRequest<MusicViewRequest, MusicViewResponse>

    public init(_ request: MusicViewRequest, endpoints: Endpoints = Endpoints()) {
        apiRequest = MizonApiRequest(httpMethod: .POST, endpoint: endpoints.musics.musicView, apiRequest: request)
        apiRequest.maximumClientCacheDuration = 300
        apiRequest.clientCacheStrategy = .disabled
    }
}
