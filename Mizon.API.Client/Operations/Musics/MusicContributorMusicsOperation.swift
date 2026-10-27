import Foundation
import MizonAPI

public struct MusicContributorMusicsOperation: APIOperation {
    public var apiRequest: MizonApiRequest<MusicContributorMusicsRequest, MusicTabMusicsResponse>

    public init(_ request: MusicContributorMusicsRequest, endpoints: Endpoints = Endpoints()) {
        apiRequest = MizonApiRequest(httpMethod: .GET, endpoint: endpoints.url("Musics/MusicContributorMusics"), apiRequest: request)
        apiRequest.maximumClientCacheDuration = 60
    }
}
