import Foundation
import MizonAPI

public struct MusicCommentCreateOperation: APIOperation {
    public var apiRequest: MizonApiRequest<MusicCommentCreateRequest, MusicCommentCreateResponse>

    public init(_ request: MusicCommentCreateRequest, endpoints: Endpoints = Endpoints()) {
        apiRequest = MizonApiRequest(httpMethod: .POST, endpoint: endpoints.url("Musics/MusicCommentCreate"), apiRequest: request)
        apiRequest.maximumClientCacheDuration = 300
        apiRequest.clientCacheStrategy = .disabled
    }
}
