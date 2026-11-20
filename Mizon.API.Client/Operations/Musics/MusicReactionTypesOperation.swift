import Foundation
import MizonAPI

public struct MusicReactionTypesOperation: APIOperation {
    public var apiRequest: MizonApiRequest<MusicReactionTypesRequest, MusicReactionTypesResponse>

    public init(_ request: MusicReactionTypesRequest, endpoints: Endpoints = Endpoints()) {
        apiRequest = MizonApiRequest(httpMethod: .GET, endpoint: endpoints.musics.musicReactionTypes, apiRequest: request)
        apiRequest.maximumClientCacheDuration = 60
    }
}
