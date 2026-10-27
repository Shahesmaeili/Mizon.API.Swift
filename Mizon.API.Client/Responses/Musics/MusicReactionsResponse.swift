import Foundation
import MizonAPI

public struct MusicReactionsResponse: IApiResponse {
    public var musicReactionItems: [MusicReactionItemResponse]

    public init(musicReactionItems: [MusicReactionItemResponse] = []) {
        self.musicReactionItems = musicReactionItems
    }

    enum CodingKeys: String, CodingKey {
        case musicReactionItems
    }

    public init(from decoder: any Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        musicReactionItems = try values.decodeIfPresent([MusicReactionItemResponse].self, forKey: .musicReactionItems) ?? []
    }
    public func encode(to encoder: any Encoder) throws {
        var c = encoder.container(keyedBy: CodingKeys.self)
        try c.encode(musicReactionItems, forKey: .musicReactionItems)
    }

}

public struct MusicReactionItemResponse: Codable, Sendable {
    public var emoji: String
    public var count: Int
    public var reactedByMe: Bool
    public var musicReactionTypePublicId: UUID

    public init(emoji: String = "", count: Int = 0, reactedByMe: Bool = false, musicReactionTypePublicId: UUID = UUID(uuid: (0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0))) {
        self.emoji = emoji
        self.count = count
        self.reactedByMe = reactedByMe
        self.musicReactionTypePublicId = musicReactionTypePublicId
    }

    enum CodingKeys: String, CodingKey {
        case emoji
        case count
        case reactedByMe
        case musicReactionTypePublicId
    }

    public init(from decoder: any Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        emoji = try values.decodeIfPresent(String.self, forKey: .emoji) ?? ""
        count = try values.decodeIfPresent(Int.self, forKey: .count) ?? 0
        reactedByMe = try values.decodeIfPresent(Bool.self, forKey: .reactedByMe) ?? false
        musicReactionTypePublicId = try values.decodeIfPresent(UUID.self, forKey: .musicReactionTypePublicId) ?? UUID(uuid: (0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0))
    }
    public func encode(to encoder: any Encoder) throws {
        var c = encoder.container(keyedBy: CodingKeys.self)
        try c.encode(emoji, forKey: .emoji)
        try c.encode(count, forKey: .count)
        try c.encode(reactedByMe, forKey: .reactedByMe)
        try c.encode(musicReactionTypePublicId, forKey: .musicReactionTypePublicId)
    }

}

