import MizonAPI

public struct MusicPlaylistDetailsOperation: APIOperation {
    public var apiRequest: MizonApiRequest<MusicPlaylistDetailsRequest, MusicPlaylistDetailsResponse>

    public init(_ request: MusicPlaylistDetailsRequest, endpoints: Endpoints = Endpoints()) {
        apiRequest = MizonApiRequest(httpMethod: .POST, endpoint: endpoints.musics.musicPlaylistDetails, apiRequest: request)
        apiRequest.clientCacheStrategy = .disabled
    }
}
