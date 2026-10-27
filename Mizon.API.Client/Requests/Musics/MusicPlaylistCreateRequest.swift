import Foundation
import MizonAPI

public struct MusicPlaylistCreateRequest: IApiRequest {
    public var musicPublicId: UUID
    public var title: String

    public init(musicPublicId: UUID = UUID(uuid: (0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0)), title: String = "") {
        self.musicPublicId = musicPublicId
        self.title = title
    }

    enum CodingKeys: String, CodingKey {
        case musicPublicId
        case title
    }

    public init(from decoder: any Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        musicPublicId = try values.decodeIfPresent(UUID.self, forKey: .musicPublicId) ?? UUID(uuid: (0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0))
        title = try values.decodeIfPresent(String.self, forKey: .title) ?? ""
    }
    public func encode(to encoder: any Encoder) throws {
        var c = encoder.container(keyedBy: CodingKeys.self)
        try c.encode(musicPublicId, forKey: .musicPublicId)
        try c.encode(title, forKey: .title)
    }

}

