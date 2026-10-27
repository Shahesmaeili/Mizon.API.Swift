import Foundation
import MizonAPI

public struct MusicPlaylistMembershipOperation: APIOperation {
    public var apiRequest: MizonApiRequest<MusicPlaylistMembershipRequest, MusicPlaylistMembershipResponse>

    public init(_ request: MusicPlaylistMembershipRequest, endpoints: Endpoints = Endpoints()) {
        apiRequest = MizonApiRequest(httpMethod: .POST, endpoint: endpoints.url("Musics/MusicPlaylistMembership"), apiRequest: request)
        apiRequest.maximumClientCacheDuration = 300
        apiRequest.clientCacheStrategy = .disabled
    }
}
