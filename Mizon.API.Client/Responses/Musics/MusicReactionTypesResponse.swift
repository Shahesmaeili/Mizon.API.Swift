import Foundation
import MizonAPI

public struct MusicReactionTypesResponse: IApiResponse {
    public var musicReactionTypes: [MusicReactionTypeItemResponse]

    public init(musicReactionTypes: [MusicReactionTypeItemResponse] = []) {
        self.musicReactionTypes = musicReactionTypes
    }

    enum CodingKeys: String, CodingKey {
        case musicReactionTypes
    }

    public init(from decoder: any Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        musicReactionTypes = try values.decodeIfPresent([MusicReactionTypeItemResponse].self, forKey: .musicReactionTypes) ?? []
    }
    public func encode(to encoder: any Encoder) throws {
        var c = encoder.container(keyedBy: CodingKeys.self)
        try c.encode(musicReactionTypes, forKey: .musicReactionTypes)
    }

}

public struct MusicReactionTypeItemResponse: Codable, Sendable {
    public var emoji: String
    public var publicId: UUID

    public init(emoji: String = "", publicId: UUID = UUID(uuid: (0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0))) {
        self.emoji = emoji
        self.publicId = publicId
    }

    enum CodingKeys: String, CodingKey {
        case emoji
        case publicId
    }

    public init(from decoder: any Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        emoji = try values.decodeIfPresent(String.self, forKey: .emoji) ?? ""
        publicId = try values.decodeIfPresent(UUID.self, forKey: .publicId) ?? UUID(uuid: (0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0))
    }
    public func encode(to encoder: any Encoder) throws {
        var c = encoder.container(keyedBy: CodingKeys.self)
        try c.encode(emoji, forKey: .emoji)
        try c.encode(publicId, forKey: .publicId)
    }

}

