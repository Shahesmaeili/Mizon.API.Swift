import Foundation
import MizonAPI

public struct MusicReactionRequest: IApiRequest {
    public var musicPublicId: UUID
    public var musicReactionTypePublicId: UUID
    public var reacted: Bool

    public init(musicPublicId: UUID = UUID(uuid: (0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0)), musicReactionTypePublicId: UUID = UUID(uuid: (0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0)), reacted: Bool = false) {
        self.musicPublicId = musicPublicId
        self.musicReactionTypePublicId = musicReactionTypePublicId
        self.reacted = reacted
    }

    enum CodingKeys: String, CodingKey {
        case musicPublicId
        case musicReactionTypePublicId
        case reacted
    }

    public init(from decoder: any Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        musicPublicId = try values.decodeIfPresent(UUID.self, forKey: .musicPublicId) ?? UUID(uuid: (0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0))
        musicReactionTypePublicId = try values.decodeIfPresent(UUID.self, forKey: .musicReactionTypePublicId) ?? UUID(uuid: (0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0))
        reacted = try values.decodeIfPresent(Bool.self, forKey: .reacted) ?? false
    }
    public func encode(to encoder: any Encoder) throws {
        var c = encoder.container(keyedBy: CodingKeys.self)
        try c.encode(musicPublicId, forKey: .musicPublicId)
        try c.encode(musicReactionTypePublicId, forKey: .musicReactionTypePublicId)
        try c.encode(reacted, forKey: .reacted)
    }

}

