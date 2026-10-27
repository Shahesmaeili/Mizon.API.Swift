import Foundation
import MizonAPI

public struct StoryLikeRequest: IApiRequest {
    public var storyPublicId: UUID
    public var liked: Bool

    public init(storyPublicId: UUID = UUID(uuid: (0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0)), liked: Bool = false) {
        self.storyPublicId = storyPublicId
        self.liked = liked
    }

    enum CodingKeys: String, CodingKey {
        case storyPublicId
        case liked
    }

    public init(from decoder: any Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        storyPublicId = try values.decodeIfPresent(UUID.self, forKey: .storyPublicId) ?? UUID(uuid: (0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0))
        liked = try values.decodeIfPresent(Bool.self, forKey: .liked) ?? false
    }
    public func encode(to encoder: any Encoder) throws {
        var c = encoder.container(keyedBy: CodingKeys.self)
        try c.encode(storyPublicId, forKey: .storyPublicId)
        try c.encode(liked, forKey: .liked)
    }

}

