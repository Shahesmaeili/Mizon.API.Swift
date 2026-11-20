import Foundation
import MizonAPI

public struct MusicCommentsResponse: IApiResponse {
    public var musicComments: [MusicCommentItemResponse]
    public var next: UUID?

    public init(musicComments: [MusicCommentItemResponse] = [], next: UUID? = nil) {
        self.musicComments = musicComments
        self.next = next
    }

    enum CodingKeys: String, CodingKey {
        case musicComments
        case next
    }

    public init(from decoder: any Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        musicComments = try values.decodeIfPresent([MusicCommentItemResponse].self, forKey: .musicComments) ?? []
        next = try values.decodeIfPresent(UUID.self, forKey: .next)
    }
    public func encode(to encoder: any Encoder) throws {
        var c = encoder.container(keyedBy: CodingKeys.self)
        try c.encode(musicComments, forKey: .musicComments)
        try c.encode(next, forKey: .next)
    }

}

public struct MusicCommentItemResponse: Codable, Sendable {
    public var publicId: UUID
    public var text: String
    public var timestamp: TimeSpan?
    public var clientPublicId: UUID
    public var profileMediaPublicId: UUID?
    public var firstName: String
    public var lastName: String
    public var username: String?
    public var parentMusicCommentPublicId: UUID?
    public var createDateTime: Date
    public var platform: String?
    public var replies: Int
    public var likes: Int
    public var dislikes: Int
    public var myVote: Int
    public var tags: [MusicCommentTagItem]

    public init(publicId: UUID = UUID(uuid: (0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0)), text: String = "", timestamp: TimeSpan? = nil, clientPublicId: UUID = UUID(uuid: (0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0)), profileMediaPublicId: UUID? = nil, firstName: String = "", lastName: String = "", username: String? = nil, parentMusicCommentPublicId: UUID? = nil, createDateTime: Date = Date(timeIntervalSince1970: -62_135_596_800), platform: String? = nil, replies: Int = 0, likes: Int = 0, dislikes: Int = 0, myVote: Int = 0, tags: [MusicCommentTagItem] = []) {
        self.publicId = publicId
        self.text = text
        self.timestamp = timestamp
        self.clientPublicId = clientPublicId
        self.profileMediaPublicId = profileMediaPublicId
        self.firstName = firstName
        self.lastName = lastName
        self.username = username
        self.parentMusicCommentPublicId = parentMusicCommentPublicId
        self.createDateTime = createDateTime
        self.platform = platform
        self.replies = replies
        self.likes = likes
        self.dislikes = dislikes
        self.myVote = myVote
        self.tags = tags
    }

    enum CodingKeys: String, CodingKey {
        case publicId
        case text
        case timestamp
        case clientPublicId
        case profileMediaPublicId
        case firstName
        case lastName
        case username
        case parentMusicCommentPublicId
        case createDateTime
        case platform
        case replies
        case likes
        case dislikes
        case myVote
        case tags
    }

    public init(from decoder: any Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        publicId = try values.decodeIfPresent(UUID.self, forKey: .publicId) ?? UUID(uuid: (0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0))
        text = try values.decodeIfPresent(String.self, forKey: .text) ?? ""
        timestamp = try values.decodeIfPresent(TimeSpan.self, forKey: .timestamp)
        clientPublicId = try values.decodeIfPresent(UUID.self, forKey: .clientPublicId) ?? UUID(uuid: (0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0))
        profileMediaPublicId = try values.decodeIfPresent(UUID.self, forKey: .profileMediaPublicId)
        firstName = try values.decodeIfPresent(String.self, forKey: .firstName) ?? ""
        lastName = try values.decodeIfPresent(String.self, forKey: .lastName) ?? ""
        username = try values.decodeIfPresent(String.self, forKey: .username)
        parentMusicCommentPublicId = try values.decodeIfPresent(UUID.self, forKey: .parentMusicCommentPublicId)
        createDateTime = try values.decodeIfPresent(Date.self, forKey: .createDateTime) ?? Date(timeIntervalSince1970: -62_135_596_800)
        platform = try values.decodeIfPresent(String.self, forKey: .platform)
        replies = try values.decodeIfPresent(Int.self, forKey: .replies) ?? 0
        likes = try values.decodeIfPresent(Int.self, forKey: .likes) ?? 0
        dislikes = try values.decodeIfPresent(Int.self, forKey: .dislikes) ?? 0
        myVote = try values.decodeIfPresent(Int.self, forKey: .myVote) ?? 0
        tags = try values.decodeIfPresent([MusicCommentTagItem].self, forKey: .tags) ?? []
    }
    public func encode(to encoder: any Encoder) throws {
        var c = encoder.container(keyedBy: CodingKeys.self)
        try c.encode(publicId, forKey: .publicId)
        try c.encode(text, forKey: .text)
        try c.encode(timestamp, forKey: .timestamp)
        try c.encode(clientPublicId, forKey: .clientPublicId)
        try c.encode(profileMediaPublicId, forKey: .profileMediaPublicId)
        try c.encode(firstName, forKey: .firstName)
        try c.encode(lastName, forKey: .lastName)
        try c.encode(username, forKey: .username)
        try c.encode(parentMusicCommentPublicId, forKey: .parentMusicCommentPublicId)
        try c.encode(createDateTime, forKey: .createDateTime)
        try c.encode(platform, forKey: .platform)
        try c.encode(replies, forKey: .replies)
        try c.encode(likes, forKey: .likes)
        try c.encode(dislikes, forKey: .dislikes)
        try c.encode(myVote, forKey: .myVote)
        try c.encode(tags, forKey: .tags)
    }

}


public struct MusicCommentTagItem: Codable, Sendable {
    public var type: String
    public var publicId: UUID
    public var label: String
    public var navigationPublicId: UUID?

    public init(type: String, publicId: UUID, label: String, navigationPublicId: UUID? = nil) {
        self.type = type
        self.publicId = publicId
        self.label = label
        self.navigationPublicId = navigationPublicId
    }
}
