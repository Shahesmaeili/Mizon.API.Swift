import Foundation
import MizonAPI

public struct MusicLikeRequest: IApiRequest {
    public var musicPublicId: UUID
    public var liked: Bool

    public init(musicPublicId: UUID = UUID(uuid: (0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0)),
                liked: Bool = false) {
        self.musicPublicId = musicPublicId
        self.liked = liked
    }

    private enum CodingKeys: String, CodingKey {
        case musicPublicId
        case liked
    }

    public init(from decoder: any Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        musicPublicId = try values.decodeIfPresent(UUID.self, forKey: .musicPublicId) ?? UUID(uuid: (0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0))
        liked = try values.decodeIfPresent(Bool.self, forKey: .liked) ?? false
    }
}
