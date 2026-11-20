import Foundation
import MizonAPI

public struct PersonFollowRequest: IApiRequest {
    public var personPublicId: UUID
    public var following: Bool?

    public init(personPublicId: UUID = UUID(uuid: (0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0)),
                following: Bool? = nil) {
        self.personPublicId = personPublicId
        self.following = following
    }

    private enum CodingKeys: String, CodingKey {
        case personPublicId
        case following
    }

    public init(from decoder: any Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        personPublicId = try values.decodeIfPresent(UUID.self, forKey: .personPublicId) ?? UUID(uuid: (0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0))
        following = try values.decodeIfPresent(Bool.self, forKey: .following)
    }
}
