import Foundation
import MizonAPI

public struct MusicStemMixOperation: APIOperation {
    public var apiRequest: MizonApiRequest<MusicStemMixRequest, MusicStemMixResponse>

    public init(_ request: MusicStemMixRequest, endpoints: Endpoints = Endpoints()) {
        apiRequest = MizonApiRequest(httpMethod: .GET, endpoint: endpoints.url("Musics/MusicStemMix"), apiRequest: request)
        apiRequest.maximumClientCacheDuration = 5
    }
}
