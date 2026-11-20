import Foundation
import MizonAPI

public struct MusicAlbumMusicsOperation: APIOperation {
    public var apiRequest: MizonApiRequest<MusicAlbumMusicsRequest, MusicTabMusicsResponse>

    public init(_ request: MusicAlbumMusicsRequest, endpoints: Endpoints = Endpoints()) {
        apiRequest = MizonApiRequest(httpMethod: .GET, endpoint: endpoints.musics.musicAlbumMusics, apiRequest: request)
        apiRequest.maximumClientCacheDuration = 60
    }
}
