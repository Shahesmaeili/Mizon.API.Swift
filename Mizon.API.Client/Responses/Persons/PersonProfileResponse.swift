import Foundation
import MizonAPI

public struct PersonProfileResponse: IApiResponse {
    public var personPublicId: UUID
    public var firstName: String
    public var lastName: String
    public var profileMediaPublicId: UUID?
    public var coverMediaPublicId: UUID?
    public var modelMediaPublicId: UUID?
    public var modelYawInDegrees: Float?
    public var followersCount: Int
    public var followingCount: Int?
    public var musicsCount: Int
    public var isFollowing: Bool
    public var canFollow: Bool

    public init(personPublicId: UUID = UUID(uuid: (0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0)),
                firstName: String = "",
                lastName: String = "",
                profileMediaPublicId: UUID? = nil,
                coverMediaPublicId: UUID? = nil,
                modelMediaPublicId: UUID? = nil,
                modelYawInDegrees: Float? = nil,
                followersCount: Int = 0,
                followingCount: Int? = nil,
                musicsCount: Int = 0,
                isFollowing: Bool = false,
                canFollow: Bool = false) {
        self.personPublicId = personPublicId
        self.firstName = firstName
        self.lastName = lastName
        self.profileMediaPublicId = profileMediaPublicId
        self.coverMediaPublicId = coverMediaPublicId
        self.modelMediaPublicId = modelMediaPublicId
        self.modelYawInDegrees = modelYawInDegrees
        self.followersCount = followersCount
        self.followingCount = followingCount
        self.musicsCount = musicsCount
        self.isFollowing = isFollowing
        self.canFollow = canFollow
    }

    private enum CodingKeys: String, CodingKey {
        case personPublicId
        case firstName
        case lastName
        case profileMediaPublicId
        case coverMediaPublicId
        case modelMediaPublicId
        case modelYawInDegrees
        case followersCount
        case followingCount
        case musicsCount
        case isFollowing
        case canFollow
    }

    public init(from decoder: any Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        personPublicId = try values.decodeIfPresent(UUID.self, forKey: .personPublicId) ?? UUID(uuid: (0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0))
        firstName = try values.decodeIfPresent(String.self, forKey: .firstName) ?? ""
        lastName = try values.decodeIfPresent(String.self, forKey: .lastName) ?? ""
        profileMediaPublicId = try values.decodeIfPresent(UUID.self, forKey: .profileMediaPublicId)
        coverMediaPublicId = try values.decodeIfPresent(UUID.self, forKey: .coverMediaPublicId)
        modelMediaPublicId = try values.decodeIfPresent(UUID.self, forKey: .modelMediaPublicId)
        modelYawInDegrees = try values.decodeIfPresent(Float.self, forKey: .modelYawInDegrees)
        followersCount = try values.decodeIfPresent(Int.self, forKey: .followersCount) ?? 0
        followingCount = try values.decodeIfPresent(Int.self, forKey: .followingCount)
        musicsCount = try values.decodeIfPresent(Int.self, forKey: .musicsCount) ?? 0
        isFollowing = try values.decodeIfPresent(Bool.self, forKey: .isFollowing) ?? false
        canFollow = try values.decodeIfPresent(Bool.self, forKey: .canFollow) ?? false
    }
}
