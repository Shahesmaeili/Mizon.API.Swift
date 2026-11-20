import Foundation
import MizonAPI

public struct PersonFollowResponse: IApiResponse {
    public var isFollowing: Bool
    public var followersCount: Int

    public init(isFollowing: Bool = false,
                followersCount: Int = 0) {
        self.isFollowing = isFollowing
        self.followersCount = followersCount
    }

    private enum CodingKeys: String, CodingKey {
        case isFollowing
        case followersCount
    }

    public init(from decoder: any Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        isFollowing = try values.decodeIfPresent(Bool.self, forKey: .isFollowing) ?? false
        followersCount = try values.decodeIfPresent(Int.self, forKey: .followersCount) ?? 0
    }
}
