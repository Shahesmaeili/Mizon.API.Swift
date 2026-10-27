import Foundation
import MizonAPI

public struct MusicViewOperation: APIOperation {
    public var apiRequest: MizonApiRequest<MusicViewRequest, MusicViewResponse>

    public init(_ request: MusicViewRequest, endpoints: Endpoints = Endpoints()) {
        apiRequest = MizonApiRequest(httpMethod: .POST, endpoint: endpoints.url("Musics/MusicView"), apiRequest: request)
        apiRequest.maximumClientCacheDuration = 300
        apiRequest.clientCacheStrategy = .disabled
    }
}
