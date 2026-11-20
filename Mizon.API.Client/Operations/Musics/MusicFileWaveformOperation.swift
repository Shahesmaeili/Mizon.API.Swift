import Foundation
import MizonAPI

public struct MusicFileWaveformOperation: APIOperation {
    public var apiRequest: MizonApiRequest<MusicFileWaveformRequest, MusicFileWaveformResponse>

    public init(_ request: MusicFileWaveformRequest, endpoints: Endpoints = Endpoints()) {
        apiRequest = MizonApiRequest(httpMethod: .GET, endpoint: endpoints.musics.musicFileWaveform, apiRequest: request)
        apiRequest.maximumClientCacheDuration = 10
    }
}
