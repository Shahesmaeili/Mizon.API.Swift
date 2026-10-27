import Foundation
import MizonAPI

public struct MusicOperation: APIOperation {
    public var apiRequest: MizonApiRequest<MusicRequest, MusicResponse>

    public init(_ request: MusicRequest, endpoints: Endpoints = Endpoints()) {
        apiRequest = MizonApiRequest(httpMethod: .GET, endpoint: endpoints.url("Musics/Music"), apiRequest: request)
        apiRequest.maximumClientCacheDuration = 10
    }
}
