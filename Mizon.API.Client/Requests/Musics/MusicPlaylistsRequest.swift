import Foundation
import MizonAPI

public struct MusicPlaylistsRequest: IApiRequest {
    public var musicPublicId: UUID?

    public init(musicPublicId: UUID? = nil) {
        self.musicPublicId = musicPublicId
    }

    enum CodingKeys: String, CodingKey {
        case musicPublicId
    }

    public init(from decoder: any Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        musicPublicId = try values.decodeIfPresent(UUID.self, forKey: .musicPublicId)
    }
    public func encode(to encoder: any Encoder) throws {
        var c = encoder.container(keyedBy: CodingKeys.self)
        try c.encodeIfPresent(musicPublicId, forKey: .musicPublicId)
    }

}

