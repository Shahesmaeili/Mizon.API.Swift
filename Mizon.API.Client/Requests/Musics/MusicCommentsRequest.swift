import Foundation
import MizonAPI

public struct MusicCommentsRequest: IApiRequest {
    public var musicPublicId: UUID
    public var musicCommentPublicId: UUID?

    public init(musicPublicId: UUID = UUID(uuid: (0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0)), musicCommentPublicId: UUID? = nil) {
        self.musicPublicId = musicPublicId
        self.musicCommentPublicId = musicCommentPublicId
    }

    enum CodingKeys: String, CodingKey {
        case musicPublicId
        case musicCommentPublicId
    }

    public init(from decoder: any Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        musicPublicId = try values.decodeIfPresent(UUID.self, forKey: .musicPublicId) ?? UUID(uuid: (0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0))
        musicCommentPublicId = try values.decodeIfPresent(UUID.self, forKey: .musicCommentPublicId)
    }
    public func encode(to encoder: any Encoder) throws {
        var c = encoder.container(keyedBy: CodingKeys.self)
        try c.encode(musicPublicId, forKey: .musicPublicId)
        try c.encodeIfPresent(musicCommentPublicId, forKey: .musicCommentPublicId)
    }

}

