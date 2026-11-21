import MizonAPI

public struct PeerMediaManifestOperation: APIOperation {
    public var apiRequest: MizonApiRequest<MediaRequest, PeerMediaManifestResponse>

    public init(_ request: MediaRequest, endpoints: Endpoints = Endpoints()) {
        apiRequest = MizonApiRequest(httpMethod: .GET, endpoint: endpoints.medias.peerManifest, apiRequest: request)
        apiRequest.clientCacheStrategy = .disabled
    }
}
