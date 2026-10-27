import Foundation
import MizonAPI

public struct MusicFileWaveformRequest: IApiRequest {
    public var musicFilePublicId: UUID

    public init(musicFilePublicId: UUID = UUID(uuid: (0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0))) {
        self.musicFilePublicId = musicFilePublicId
    }

    enum CodingKeys: String, CodingKey {
        case musicFilePublicId
    }

    public init(from decoder: any Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        musicFilePublicId = try values.decodeIfPresent(UUID.self, forKey: .musicFilePublicId) ?? UUID(uuid: (0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0))
    }
    public func encode(to encoder: any Encoder) throws {
        var c = encoder.container(keyedBy: CodingKeys.self)
        try c.encode(musicFilePublicId, forKey: .musicFilePublicId)
    }

}

