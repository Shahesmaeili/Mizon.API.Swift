import MizonAPI

public struct MusicFeaturesOperation: APIOperation {
    public var apiRequest: MizonApiRequest<MusicFeaturesRequest, MusicFeaturesResponse>

    public init(_ request: MusicFeaturesRequest, endpoints: Endpoints = Endpoints()) {
        apiRequest = MizonApiRequest(httpMethod: .POST, endpoint: endpoints.musics.musicFeatures, apiRequest: request)
        apiRequest.clientCacheStrategy = .disabled
    }
}
