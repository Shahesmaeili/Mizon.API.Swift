import Foundation
import MizonAPI

public struct MusicReactionsOperation: APIOperation {
    public var apiRequest: MizonApiRequest<MusicReactionsRequest, MusicReactionsResponse>

    public init(_ request: MusicReactionsRequest, endpoints: Endpoints = Endpoints()) {
        apiRequest = MizonApiRequest(httpMethod: .GET, endpoint: endpoints.musics.musicReactions, apiRequest: request)
        apiRequest.maximumClientCacheDuration = 10
    }
}
