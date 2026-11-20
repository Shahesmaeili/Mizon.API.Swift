import MizonAPI

public struct MusicCommentVoteResponse: IApiResponse {
    public var likes: Int
    public var dislikes: Int
    public var myVote: Int

    public init(likes: Int = 0, dislikes: Int = 0, myVote: Int = 0) {
        self.likes = likes
        self.dislikes = dislikes
        self.myVote = myVote
    }
}
