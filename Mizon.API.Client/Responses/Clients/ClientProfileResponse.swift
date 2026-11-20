import Foundation
import MizonAPI

public struct ClientProfileResponse: IApiResponse {
    public var clientPublicId: UUID
    public var firstName: String
    public var lastName: String
    public var nickName: String?
    public var username: String?
    public var profileMediaPublicId: UUID?
    public var primaryAccentColor: String?

    public init(clientPublicId: UUID = UUID(uuid: (0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0)),
                firstName: String = "",
                lastName: String = "",
                nickName: String? = nil,
                username: String? = nil,
                profileMediaPublicId: UUID? = nil,
                primaryAccentColor: String? = nil) {
        self.clientPublicId = clientPublicId
        self.firstName = firstName
        self.lastName = lastName
        self.nickName = nickName
        self.username = username
        self.profileMediaPublicId = profileMediaPublicId
        self.primaryAccentColor = primaryAccentColor
    }

    private enum CodingKeys: String, CodingKey {
        case clientPublicId
        case firstName
        case lastName
        case nickName
        case username
        case profileMediaPublicId
        case primaryAccentColor
    }

    public init(from decoder: any Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        clientPublicId = try values.decodeIfPresent(UUID.self, forKey: .clientPublicId) ?? UUID(uuid: (0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0))
        firstName = try values.decodeIfPresent(String.self, forKey: .firstName) ?? ""
        lastName = try values.decodeIfPresent(String.self, forKey: .lastName) ?? ""
        nickName = try values.decodeIfPresent(String.self, forKey: .nickName)
        username = try values.decodeIfPresent(String.self, forKey: .username)
        profileMediaPublicId = try values.decodeIfPresent(UUID.self, forKey: .profileMediaPublicId)
        primaryAccentColor = try values.decodeIfPresent(String.self, forKey: .primaryAccentColor)
    }
}
