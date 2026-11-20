import MizonAPI

public struct MusicCommentTagSearchOperation: APIOperation {
    public var apiRequest: MizonApiRequest<MusicCommentTagSearchRequest, MusicCommentTagSearchResponse>

    public init(_ request: MusicCommentTagSearchRequest, endpoints: Endpoints = Endpoints()) {
        apiRequest = MizonApiRequest(httpMethod: .GET, endpoint: endpoints.musics.musicCommentTagSearch, apiRequest: request)
        apiRequest.clientCacheStrategy = .disabled
    }
}
