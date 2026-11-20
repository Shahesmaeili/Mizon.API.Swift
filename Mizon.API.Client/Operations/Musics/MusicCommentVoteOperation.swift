import MizonAPI

public struct MusicCommentVoteOperation: APIOperation {
    public var apiRequest: MizonApiRequest<MusicCommentVoteRequest, MusicCommentVoteResponse>

    public init(_ request: MusicCommentVoteRequest, endpoints: Endpoints = Endpoints()) {
        apiRequest = MizonApiRequest(httpMethod: .POST, endpoint: endpoints.musics.musicCommentVote, apiRequest: request)
        apiRequest.clientCacheStrategy = .disabled
    }
}
