import Foundation
import MizonAPI

public struct MusicPlaylistCreateOperation: APIOperation {
    public var apiRequest: MizonApiRequest<MusicPlaylistCreateRequest, MusicPlaylistCreateResponse>

    public init(_ request: MusicPlaylistCreateRequest, endpoints: Endpoints = Endpoints()) {
        apiRequest = MizonApiRequest(httpMethod: .POST, endpoint: endpoints.url("Musics/MusicPlaylistCreate"), apiRequest: request)
        apiRequest.maximumClientCacheDuration = 300
        apiRequest.clientCacheStrategy = .disabled
    }
}
