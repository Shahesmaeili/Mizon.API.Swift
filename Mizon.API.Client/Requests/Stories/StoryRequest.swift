import Foundation
import MizonAPI

public struct StoryRequest: IApiRequest {
    public var storyPublicId: UUID

    public init(storyPublicId: UUID = UUID(uuid: (0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0))) {
        self.storyPublicId = storyPublicId
    }

    enum CodingKeys: String, CodingKey {
        case storyPublicId
    }

    public init(from decoder: any Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        storyPublicId = try values.decodeIfPresent(UUID.self, forKey: .storyPublicId) ?? UUID(uuid: (0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0))
    }
    public func encode(to encoder: any Encoder) throws {
        var c = encoder.container(keyedBy: CodingKeys.self)
        try c.encode(storyPublicId, forKey: .storyPublicId)
    }

}

