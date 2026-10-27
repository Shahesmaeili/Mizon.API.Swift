import Foundation
import MizonAPI

public struct MeResponse: IApiResponse {
    public var firstName: String
    public var lastName: String
    public var username: String?
    public var nickName: String?
    public var emailAddress: String
    public var emailAddressIsVerified: Bool
    public var meProfile: MeProfileResponse?

    public init(firstName: String = "", lastName: String = "", username: String? = nil, nickName: String? = nil, emailAddress: String = "", emailAddressIsVerified: Bool = false, meProfile: MeProfileResponse? = nil) {
        self.firstName = firstName
        self.lastName = lastName
        self.username = username
        self.nickName = nickName
        self.emailAddress = emailAddress
        self.emailAddressIsVerified = emailAddressIsVerified
        self.meProfile = meProfile
    }

    enum CodingKeys: String, CodingKey {
        case firstName
        case lastName
        case username
        case nickName
        case emailAddress
        case emailAddressIsVerified
        case meProfile
    }

    public init(from decoder: any Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        firstName = try values.decodeIfPresent(String.self, forKey: .firstName) ?? ""
        lastName = try values.decodeIfPresent(String.self, forKey: .lastName) ?? ""
        username = try values.decodeIfPresent(String.self, forKey: .username)
        nickName = try values.decodeIfPresent(String.self, forKey: .nickName)
        emailAddress = try values.decodeIfPresent(String.self, forKey: .emailAddress) ?? ""
        emailAddressIsVerified = try values.decodeIfPresent(Bool.self, forKey: .emailAddressIsVerified) ?? false
        meProfile = try values.decodeIfPresent(MeProfileResponse.self, forKey: .meProfile)
    }
    public func encode(to encoder: any Encoder) throws {
        var c = encoder.container(keyedBy: CodingKeys.self)
        try c.encode(firstName, forKey: .firstName)
        try c.encode(lastName, forKey: .lastName)
        try c.encode(username, forKey: .username)
        try c.encode(nickName, forKey: .nickName)
        try c.encode(emailAddress, forKey: .emailAddress)
        try c.encode(emailAddressIsVerified, forKey: .emailAddressIsVerified)
        try c.encode(meProfile, forKey: .meProfile)
    }

}

public struct MeProfileResponse: Codable, Sendable {
    public var mediaPublicId: UUID
    public var fileSize: Int64
    public var blurhash: String
    public var width: Int16
    public var height: Int16
    public var primaryAccentColor: String

    public init(mediaPublicId: UUID = UUID(uuid: (0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0)), fileSize: Int64 = 0, blurhash: String = "", width: Int16 = 0, height: Int16 = 0, primaryAccentColor: String = "") {
        self.mediaPublicId = mediaPublicId
        self.fileSize = fileSize
        self.blurhash = blurhash
        self.width = width
        self.height = height
        self.primaryAccentColor = primaryAccentColor
    }

    enum CodingKeys: String, CodingKey {
        case mediaPublicId
        case fileSize
        case blurhash
        case width
        case height
        case primaryAccentColor
    }

    public init(from decoder: any Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        mediaPublicId = try values.decodeIfPresent(UUID.self, forKey: .mediaPublicId) ?? UUID(uuid: (0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0))
        fileSize = try values.decodeIfPresent(Int64.self, forKey: .fileSize) ?? 0
        blurhash = try values.decodeIfPresent(String.self, forKey: .blurhash) ?? ""
        width = try values.decodeIfPresent(Int16.self, forKey: .width) ?? 0
        height = try values.decodeIfPresent(Int16.self, forKey: .height) ?? 0
        primaryAccentColor = try values.decodeIfPresent(String.self, forKey: .primaryAccentColor) ?? ""
    }
    public func encode(to encoder: any Encoder) throws {
        var c = encoder.container(keyedBy: CodingKeys.self)
        try c.encode(mediaPublicId, forKey: .mediaPublicId)
        try c.encode(fileSize, forKey: .fileSize)
        try c.encode(blurhash, forKey: .blurhash)
        try c.encode(width, forKey: .width)
        try c.encode(height, forKey: .height)
        try c.encode(primaryAccentColor, forKey: .primaryAccentColor)
    }

}

