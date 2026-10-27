import Foundation
import MizonAPI

public struct MusicCommentCreateRequest: IApiRequest {
    public var musicPublicId: UUID
    public var text: String
    public var timestamp: TimeSpan?

    public init(musicPublicId: UUID = UUID(uuid: (0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0)), text: String = "", timestamp: TimeSpan? = nil) {
        self.musicPublicId = musicPublicId
        self.text = text
        self.timestamp = timestamp
    }

    enum CodingKeys: String, CodingKey {
        case musicPublicId
        case text
        case timestamp
    }

    public init(from decoder: any Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        musicPublicId = try values.decodeIfPresent(UUID.self, forKey: .musicPublicId) ?? UUID(uuid: (0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0))
        text = try values.decodeIfPresent(String.self, forKey: .text) ?? ""
        timestamp = try values.decodeIfPresent(TimeSpan.self, forKey: .timestamp)
    }
    public func encode(to encoder: any Encoder) throws {
        var c = encoder.container(keyedBy: CodingKeys.self)
        try c.encode(musicPublicId, forKey: .musicPublicId)
        try c.encode(text, forKey: .text)
        try c.encode(timestamp, forKey: .timestamp)
    }

}

