import Foundation
import MizonAPI

public struct StoriesRequest: IApiRequest {
    public var storyPublicId: UUID?
    public var musicPublicId: UUID?

    public init(storyPublicId: UUID? = nil, musicPublicId: UUID? = nil) {
        self.storyPublicId = storyPublicId
        self.musicPublicId = musicPublicId
    }

    enum CodingKeys: String, CodingKey {
        case storyPublicId
        case musicPublicId
    }

    public init(from decoder: any Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        storyPublicId = try values.decodeIfPresent(UUID.self, forKey: .storyPublicId)
        musicPublicId = try values.decodeIfPresent(UUID.self, forKey: .musicPublicId)
    }
    public func encode(to encoder: any Encoder) throws {
        var c = encoder.container(keyedBy: CodingKeys.self)
        try c.encode(storyPublicId, forKey: .storyPublicId)
        try c.encode(musicPublicId, forKey: .musicPublicId)
    }

}

