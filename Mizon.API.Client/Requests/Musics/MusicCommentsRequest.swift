import Foundation
import MizonAPI

public struct MusicCommentsRequest: IApiRequest, APIQueryRequest {
    public var musicPublicId: UUID
    public var musicCommentPublicId: UUID?
    public var parentMusicCommentPublicId: UUID?
    public var after: UUID?
    public var pageSize: Int?
    public var sort: String?
    public var timedOnly: Bool?

    public init(musicPublicId: UUID = UUID(uuid: (0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0)), musicCommentPublicId: UUID? = nil, parentMusicCommentPublicId: UUID? = nil, after: UUID? = nil, pageSize: Int? = nil, sort: String? = nil, timedOnly: Bool? = nil) {
        self.musicPublicId = musicPublicId
        self.musicCommentPublicId = musicCommentPublicId
        self.parentMusicCommentPublicId = parentMusicCommentPublicId
        self.after = after
        self.pageSize = pageSize
        self.sort = sort
        self.timedOnly = timedOnly
    }

    enum CodingKeys: String, CodingKey {
        case musicPublicId
        case musicCommentPublicId
        case parentMusicCommentPublicId
        case after
        case pageSize
        case sort
        case timedOnly
    }

    public init(from decoder: any Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        musicPublicId = try values.decodeIfPresent(UUID.self, forKey: .musicPublicId) ?? UUID(uuid: (0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0))
        musicCommentPublicId = try values.decodeIfPresent(UUID.self, forKey: .musicCommentPublicId)
        parentMusicCommentPublicId = try values.decodeIfPresent(UUID.self, forKey: .parentMusicCommentPublicId)
        after = try values.decodeIfPresent(UUID.self, forKey: .after)
        pageSize = try values.decodeIfPresent(Int.self, forKey: .pageSize)
        sort = try values.decodeIfPresent(String.self, forKey: .sort)
        timedOnly = try values.decodeIfPresent(Bool.self, forKey: .timedOnly)
    }
    public func encode(to encoder: any Encoder) throws {
        var c = encoder.container(keyedBy: CodingKeys.self)
        try c.encode(musicPublicId, forKey: .musicPublicId)
        try c.encodeIfPresent(musicCommentPublicId, forKey: .musicCommentPublicId)
        try c.encodeIfPresent(parentMusicCommentPublicId, forKey: .parentMusicCommentPublicId)
        try c.encodeIfPresent(after, forKey: .after)
        try c.encodeIfPresent(pageSize, forKey: .pageSize)
        try c.encodeIfPresent(sort, forKey: .sort)
        try c.encodeIfPresent(timedOnly, forKey: .timedOnly)
    }

    public func queryItems() -> [URLQueryItem] {
        var items = [URLQueryItem(name: "MusicPublicId", value: musicPublicId.uuidString.lowercased())]
        if let musicCommentPublicId { items.append(.init(name: "MusicCommentPublicId", value: musicCommentPublicId.uuidString.lowercased())) }
        if let parentMusicCommentPublicId { items.append(.init(name: "ParentMusicCommentPublicId", value: parentMusicCommentPublicId.uuidString.lowercased())) }
        if let after { items.append(.init(name: "After", value: after.uuidString.lowercased())) }
        if let pageSize { items.append(.init(name: "PageSize", value: String(pageSize))) }
        if let sort { items.append(.init(name: "Sort", value: sort)) }
        if timedOnly == true { items.append(.init(name: "TimedOnly", value: "true")) }
        return items
    }
}
