import Foundation
import MizonAPI

public struct MusicLyricOperation: APIOperation {
    public var apiRequest: MizonApiRequest<MusicLyricRequest, MusicLyricResponse>

    public init(_ request: MusicLyricRequest, endpoints: Endpoints = Endpoints()) {
        apiRequest = MizonApiRequest(httpMethod: .GET, endpoint: endpoints.url("Musics/MusicLyric"), apiRequest: request)
        apiRequest.maximumClientCacheDuration = 10
    }
}
