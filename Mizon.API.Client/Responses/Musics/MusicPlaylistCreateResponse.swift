import Foundation
import MizonAPI

public struct MusicPlaylistCreateResponse: IApiResponse {
    public var musicPlaylistPublicId: UUID

    public init(musicPlaylistPublicId: UUID = UUID(uuid: (0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0))) {
        self.musicPlaylistPublicId = musicPlaylistPublicId
    }

    enum CodingKeys: String, CodingKey {
        case musicPlaylistPublicId
    }

    public init(from decoder: any Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        musicPlaylistPublicId = try values.decodeIfPresent(UUID.self, forKey: .musicPlaylistPublicId) ?? UUID(uuid: (0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0))
    }
    public func encode(to encoder: any Encoder) throws {
        var c = encoder.container(keyedBy: CodingKeys.self)
        try c.encode(musicPlaylistPublicId, forKey: .musicPlaylistPublicId)
    }

}

