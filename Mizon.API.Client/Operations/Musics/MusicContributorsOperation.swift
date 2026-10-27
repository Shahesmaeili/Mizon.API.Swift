import Foundation
import MizonAPI

public struct MusicContributorsOperation: APIOperation {
    public var apiRequest: MizonApiRequest<MusicContributorRequest, MusicContributorsResponse>

    public init(_ request: MusicContributorRequest, endpoints: Endpoints = Endpoints()) {
        apiRequest = MizonApiRequest(httpMethod: .GET, endpoint: endpoints.url("Musics/MusicContributors"), apiRequest: request)
        apiRequest.maximumClientCacheDuration = 10
    }
}
