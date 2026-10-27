import Foundation
import MizonAPI

public struct MusicPlaylistsOperation: APIOperation {
    public var apiRequest: MizonApiRequest<MusicPlaylistsRequest, MusicPlaylistsResponse>

    public init(_ request: MusicPlaylistsRequest, endpoints: Endpoints = Endpoints()) {
        apiRequest = MizonApiRequest(httpMethod: .POST, endpoint: endpoints.url("Musics/MusicPlaylists"), apiRequest: request)
        apiRequest.maximumClientCacheDuration = 300
        apiRequest.clientCacheStrategy = .disabled
    }
}
