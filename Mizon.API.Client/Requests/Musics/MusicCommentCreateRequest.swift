import Foundation
import MizonAPI

public struct MusicCommentCreateRequest: IApiRequest {
    public var musicPublicId: UUID
    public var text: String
    public var timestamp: TimeSpan?
    public var parentMusicCommentPublicId: UUID?
    public var tags: [MusicCommentTagRequest]?

    public init(musicPublicId: UUID = UUID(uuid: (0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0)), text: String = "", timestamp: TimeSpan? = nil, parentMusicCommentPublicId: UUID? = nil, tags: [MusicCommentTagRequest]? = nil) {
        self.musicPublicId = musicPublicId
        self.text = text
        self.timestamp = timestamp
        self.parentMusicCommentPublicId = parentMusicCommentPublicId
        self.tags = tags
    }

    enum CodingKeys: String, CodingKey {
        case musicPublicId
        case text
        case timestamp
        case parentMusicCommentPublicId
        case tags
    }

    public init(from decoder: any Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        musicPublicId = try values.decodeIfPresent(UUID.self, forKey: .musicPublicId) ?? UUID(uuid: (0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0))
        text = try values.decodeIfPresent(String.self, forKey: .text) ?? ""
        timestamp = try values.decodeIfPresent(TimeSpan.self, forKey: .timestamp)
        parentMusicCommentPublicId = try values.decodeIfPresent(UUID.self, forKey: .parentMusicCommentPublicId)
        tags = try values.decodeIfPresent([MusicCommentTagRequest].self, forKey: .tags)
    }
    public func encode(to encoder: any Encoder) throws {
        var c = encoder.container(keyedBy: CodingKeys.self)
        try c.encode(musicPublicId, forKey: .musicPublicId)
        try c.encode(text, forKey: .text)
        try c.encode(timestamp, forKey: .timestamp)
        try c.encode(parentMusicCommentPublicId, forKey: .parentMusicCommentPublicId)
        try c.encode(tags, forKey: .tags)
    }

}


public struct MusicCommentTagRequest: Codable, Sendable {
    public var type: String
    public var publicId: UUID

    public init(type: String, publicId: UUID) {
        self.type = type
        self.publicId = publicId
    }
}
