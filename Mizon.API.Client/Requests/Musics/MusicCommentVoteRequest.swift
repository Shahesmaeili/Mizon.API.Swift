import Foundation
import MizonAPI

public struct MusicCommentVoteRequest: IApiRequest {
    public var musicPublicId: UUID
    public var musicCommentPublicId: UUID
    public var vote: Int

    public init(musicPublicId: UUID, musicCommentPublicId: UUID, vote: Int) {
        self.musicPublicId = musicPublicId
        self.musicCommentPublicId = musicCommentPublicId
        self.vote = vote
    }
}
