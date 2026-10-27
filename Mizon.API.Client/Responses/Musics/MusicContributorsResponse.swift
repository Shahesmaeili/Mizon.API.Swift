import Foundation
import MizonAPI

public struct MusicContributorsResponse: IApiResponse {
    public var contributors: [MusicContributorItemResponse]

    public init(contributors: [MusicContributorItemResponse] = []) {
        self.contributors = contributors
    }

    enum CodingKeys: String, CodingKey {
        case contributors
    }

    public init(from decoder: any Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        contributors = try values.decodeIfPresent([MusicContributorItemResponse].self, forKey: .contributors) ?? []
    }
    public func encode(to encoder: any Encoder) throws {
        var c = encoder.container(keyedBy: CodingKeys.self)
        try c.encode(contributors, forKey: .contributors)
    }

}

public struct MusicContributorItemResponse: Codable, Sendable {
    public var personPublicId: UUID
    public var firstName: String
    public var lastName: String
    public var profileMediaPublicId: UUID?
    public var musicContributorTypePublicId: UUID
    public var musicContributorTypeTitle: String
    public var musicContributorTypePersianTitle: String?

    public init(personPublicId: UUID = UUID(uuid: (0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0)), firstName: String = "", lastName: String = "", profileMediaPublicId: UUID? = nil, musicContributorTypePublicId: UUID = UUID(uuid: (0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0)), musicContributorTypeTitle: String = "", musicContributorTypePersianTitle: String? = nil) {
        self.personPublicId = personPublicId
        self.firstName = firstName
        self.lastName = lastName
        self.profileMediaPublicId = profileMediaPublicId
        self.musicContributorTypePublicId = musicContributorTypePublicId
        self.musicContributorTypeTitle = musicContributorTypeTitle
        self.musicContributorTypePersianTitle = musicContributorTypePersianTitle
    }

    enum CodingKeys: String, CodingKey {
        case personPublicId
        case firstName
        case lastName
        case profileMediaPublicId
        case musicContributorTypePublicId
        case musicContributorTypeTitle
        case musicContributorTypePersianTitle
    }

    public init(from decoder: any Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        personPublicId = try values.decodeIfPresent(UUID.self, forKey: .personPublicId) ?? UUID(uuid: (0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0))
        firstName = try values.decodeIfPresent(String.self, forKey: .firstName) ?? ""
        lastName = try values.decodeIfPresent(String.self, forKey: .lastName) ?? ""
        profileMediaPublicId = try values.decodeIfPresent(UUID.self, forKey: .profileMediaPublicId)
        musicContributorTypePublicId = try values.decodeIfPresent(UUID.self, forKey: .musicContributorTypePublicId) ?? UUID(uuid: (0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0))
        musicContributorTypeTitle = try values.decodeIfPresent(String.self, forKey: .musicContributorTypeTitle) ?? ""
        musicContributorTypePersianTitle = try values.decodeIfPresent(String.self, forKey: .musicContributorTypePersianTitle)
    }
    public func encode(to encoder: any Encoder) throws {
        var c = encoder.container(keyedBy: CodingKeys.self)
        try c.encode(personPublicId, forKey: .personPublicId)
        try c.encode(firstName, forKey: .firstName)
        try c.encode(lastName, forKey: .lastName)
        try c.encode(profileMediaPublicId, forKey: .profileMediaPublicId)
        try c.encode(musicContributorTypePublicId, forKey: .musicContributorTypePublicId)
        try c.encode(musicContributorTypeTitle, forKey: .musicContributorTypeTitle)
        try c.encode(musicContributorTypePersianTitle, forKey: .musicContributorTypePersianTitle)
    }

}

