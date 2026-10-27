import Foundation
import MizonAPI

public struct MusicReactionOperation: APIOperation {
    public var apiRequest: MizonApiRequest<MusicReactionRequest, MusicReactionResponse>

    public init(_ request: MusicReactionRequest, endpoints: Endpoints = Endpoints()) {
        apiRequest = MizonApiRequest(httpMethod: .POST, endpoint: endpoints.url("Musics/MusicReaction"), apiRequest: request)
        apiRequest.maximumClientCacheDuration = 300
        apiRequest.clientCacheStrategy = .disabled
    }
}
