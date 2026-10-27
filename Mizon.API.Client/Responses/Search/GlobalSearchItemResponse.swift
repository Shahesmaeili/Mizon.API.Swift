import Foundation
import MizonAPI

public struct GlobalSearchItemResponse: IApiResponse {
    public var itemType: String
    public var publicId: UUID
    public var username: String?
    public var firstName: String?
    public var lastName: String?
    public var nickName: String?
    public var profileMediaPublicId: UUID?
    public var title: String?
    public var persianTitle: String?
    public var coverMediaPublicId: UUID?

    public init(itemType: String = "", publicId: UUID = UUID(uuid: (0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0)), username: String? = nil, firstName: String? = nil, lastName: String? = nil, nickName: String? = nil, profileMediaPublicId: UUID? = nil, title: String? = nil, persianTitle: String? = nil, coverMediaPublicId: UUID? = nil) {
        self.itemType = itemType
        self.publicId = publicId
        self.username = username
        self.firstName = firstName
        self.lastName = lastName
        self.nickName = nickName
        self.profileMediaPublicId = profileMediaPublicId
        self.title = title
        self.persianTitle = persianTitle
        self.coverMediaPublicId = coverMediaPublicId
    }

    enum CodingKeys: String, CodingKey {
        case itemType
        case publicId
        case username
        case firstName
        case lastName
        case nickName
        case profileMediaPublicId
        case title
        case persianTitle
        case coverMediaPublicId
    }

    public init(from decoder: any Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        itemType = try values.decodeIfPresent(String.self, forKey: .itemType) ?? ""
        publicId = try values.decodeIfPresent(UUID.self, forKey: .publicId) ?? UUID(uuid: (0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0))
        username = try values.decodeIfPresent(String.self, forKey: .username)
        firstName = try values.decodeIfPresent(String.self, forKey: .firstName)
        lastName = try values.decodeIfPresent(String.self, forKey: .lastName)
        nickName = try values.decodeIfPresent(String.self, forKey: .nickName)
        profileMediaPublicId = try values.decodeIfPresent(UUID.self, forKey: .profileMediaPublicId)
        title = try values.decodeIfPresent(String.self, forKey: .title)
        persianTitle = try values.decodeIfPresent(String.self, forKey: .persianTitle)
        coverMediaPublicId = try values.decodeIfPresent(UUID.self, forKey: .coverMediaPublicId)
    }
    public func encode(to encoder: any Encoder) throws {
        var c = encoder.container(keyedBy: CodingKeys.self)
        try c.encode(itemType, forKey: .itemType)
        try c.encode(publicId, forKey: .publicId)
        try c.encode(username, forKey: .username)
        try c.encode(firstName, forKey: .firstName)
        try c.encode(lastName, forKey: .lastName)
        try c.encode(nickName, forKey: .nickName)
        try c.encode(profileMediaPublicId, forKey: .profileMediaPublicId)
        try c.encode(title, forKey: .title)
        try c.encode(persianTitle, forKey: .persianTitle)
        try c.encode(coverMediaPublicId, forKey: .coverMediaPublicId)
    }

}

