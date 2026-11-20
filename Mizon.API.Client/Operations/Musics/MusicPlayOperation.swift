import MizonAPI

public struct MusicPlayOperation: APIOperation {
    public var apiRequest: MizonApiRequest<MusicPlayRequest, MusicPlayResponse>

    public init(_ request: MusicPlayRequest, endpoints: Endpoints = Endpoints()) {
        apiRequest = MizonApiRequest(httpMethod: .POST, endpoint: endpoints.musics.musicPlay, apiRequest: request)
        apiRequest.clientCacheStrategy = .disabled
    }
}
