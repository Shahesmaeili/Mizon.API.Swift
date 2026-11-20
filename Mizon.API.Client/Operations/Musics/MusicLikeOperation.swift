import MizonAPI

public struct MusicLikeOperation: APIOperation {
    public var apiRequest: MizonApiRequest<MusicLikeRequest, MusicLikeResponse>

    public init(_ request: MusicLikeRequest, endpoints: Endpoints = Endpoints()) {
        apiRequest = MizonApiRequest(httpMethod: .POST, endpoint: endpoints.musics.musicLike, apiRequest: request)
        apiRequest.clientCacheStrategy = .disabled
    }
}
