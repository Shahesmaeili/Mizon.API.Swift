import Foundation
import MizonAPI

public struct MusicLikeResponse: IApiResponse {
    public var musicPublicId: UUID
    public var likedByMe: Bool
    public var likesCount: Int

    public init(musicPublicId: UUID = UUID(uuid: (0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0)),
                likedByMe: Bool = false,
                likesCount: Int = 0) {
        self.musicPublicId = musicPublicId
        self.likedByMe = likedByMe
        self.likesCount = likesCount
    }

    private enum CodingKeys: String, CodingKey {
        case musicPublicId
        case likedByMe
        case likesCount
    }

    public init(from decoder: any Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        musicPublicId = try values.decodeIfPresent(UUID.self, forKey: .musicPublicId) ?? UUID(uuid: (0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0))
        likedByMe = try values.decodeIfPresent(Bool.self, forKey: .likedByMe) ?? false
        likesCount = try values.decodeIfPresent(Int.self, forKey: .likesCount) ?? 0
    }
}
