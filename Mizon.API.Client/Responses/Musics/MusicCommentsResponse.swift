import Foundation
import MizonAPI

public struct MusicCommentsResponse: IApiResponse {
    public var musicComments: [MusicCommentItemResponse]

    public init(musicComments: [MusicCommentItemResponse] = []) {
        self.musicComments = musicComments
    }

    enum CodingKeys: String, CodingKey {
        case musicComments
    }

    public init(from decoder: any Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        musicComments = try values.decodeIfPresent([MusicCommentItemResponse].self, forKey: .musicComments) ?? []
    }
    public func encode(to encoder: any Encoder) throws {
        var c = encoder.container(keyedBy: CodingKeys.self)
        try c.encode(musicComments, forKey: .musicComments)
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

    public init(publicId: UUID = UUID(uuid: (0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0)), text: String = "", timestamp: TimeSpan? = nil, clientPublicId: UUID = UUID(uuid: (0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0)), profileMediaPublicId: UUID? = nil, firstName: String = "", lastName: String = "", username: String? = nil) {
        self.publicId = publicId
        self.text = text
        self.timestamp = timestamp
        self.clientPublicId = clientPublicId
        self.profileMediaPublicId = profileMediaPublicId
        self.firstName = firstName
        self.lastName = lastName
        self.username = username
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
    }

}

