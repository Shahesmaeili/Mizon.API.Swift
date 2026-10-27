import Foundation
import MizonAPI

public struct MusicGenreTypesOperation: APIOperation {
    public var apiRequest: MizonApiRequest<MusicGenreTypesRequest, MusicGenreTypesResponse>

    public init(_ request: MusicGenreTypesRequest, endpoints: Endpoints = Endpoints()) {
        apiRequest = MizonApiRequest(httpMethod: .GET, endpoint: endpoints.url("Musics/MusicGenreTypes"), apiRequest: request)
        apiRequest.maximumClientCacheDuration = 300
    }
}
