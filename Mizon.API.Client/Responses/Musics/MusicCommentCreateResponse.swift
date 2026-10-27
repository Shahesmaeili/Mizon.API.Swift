import Foundation
import MizonAPI

public struct MusicCommentCreateResponse: IApiResponse {
    public var musicCommentPublicId: UUID

    public init(musicCommentPublicId: UUID = UUID(uuid: (0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0))) {
        self.musicCommentPublicId = musicCommentPublicId
    }

    enum CodingKeys: String, CodingKey {
        case musicCommentPublicId
    }

    public init(from decoder: any Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        musicCommentPublicId = try values.decodeIfPresent(UUID.self, forKey: .musicCommentPublicId) ?? UUID(uuid: (0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0))
    }
    public func encode(to encoder: any Encoder) throws {
        var c = encoder.container(keyedBy: CodingKeys.self)
        try c.encode(musicCommentPublicId, forKey: .musicCommentPublicId)
    }

}

