import Foundation
import MizonAPI

public struct MediaOperation: APIOperation {
    public var apiRequest: MizonApiRequest<MediaRequest, MediaResponse>

    public init(_ request: MediaRequest, endpoints: Endpoints = Endpoints()) {
        apiRequest = MizonApiRequest(httpMethod: .GET, endpoint: endpoints.url("Medias/Media"), apiRequest: request)
        apiRequest.maximumClientCacheDuration = 10
    }
}
