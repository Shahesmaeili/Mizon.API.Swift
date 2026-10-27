import Foundation
import MizonAPI

public struct MusicLyricLineOperation: APIOperation {
    public var apiRequest: MizonApiRequest<MusicLyricLineRequest, MusicLyricLineResponse>

    public init(_ request: MusicLyricLineRequest, endpoints: Endpoints = Endpoints()) {
        apiRequest = MizonApiRequest(httpMethod: .GET, endpoint: endpoints.url("Musics/MusicLyricLine"), apiRequest: request)
        apiRequest.maximumClientCacheDuration = 10
    }
}
