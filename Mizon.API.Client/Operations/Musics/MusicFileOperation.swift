import Foundation
import MizonAPI

public struct MusicFileOperation: APIOperation {
    public var apiRequest: MizonApiRequest<MusicFileRequest, MusicFileResponse>

    public init(_ request: MusicFileRequest, endpoints: Endpoints = Endpoints()) {
        apiRequest = MizonApiRequest(httpMethod: .GET, endpoint: endpoints.musics.musicFile, apiRequest: request)
        apiRequest.maximumClientCacheDuration = 10
    }
}
