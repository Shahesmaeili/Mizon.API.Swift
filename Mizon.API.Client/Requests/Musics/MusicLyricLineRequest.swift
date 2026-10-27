import Foundation
import MizonAPI

public struct MusicLyricLineRequest: IApiRequest {
    public var musicLyricPublicId: UUID

    public init(musicLyricPublicId: UUID = UUID(uuid: (0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0))) {
        self.musicLyricPublicId = musicLyricPublicId
    }

    enum CodingKeys: String, CodingKey {
        case musicLyricPublicId
    }

    public init(from decoder: any Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        musicLyricPublicId = try values.decodeIfPresent(UUID.self, forKey: .musicLyricPublicId) ?? UUID(uuid: (0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0))
    }
    public func encode(to encoder: any Encoder) throws {
        var c = encoder.container(keyedBy: CodingKeys.self)
        try c.encode(musicLyricPublicId, forKey: .musicLyricPublicId)
    }

}

