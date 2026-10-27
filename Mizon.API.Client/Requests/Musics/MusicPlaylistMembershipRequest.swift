import Foundation
import MizonAPI

public struct MusicPlaylistMembershipRequest: IApiRequest {
    public var musicPublicId: UUID
    public var musicPlaylistPublicIds: [UUID]

    public init(musicPublicId: UUID = UUID(uuid: (0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0)), musicPlaylistPublicIds: [UUID] = []) {
        self.musicPublicId = musicPublicId
        self.musicPlaylistPublicIds = musicPlaylistPublicIds
    }

    enum CodingKeys: String, CodingKey {
        case musicPublicId
        case musicPlaylistPublicIds
    }

    public init(from decoder: any Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        musicPublicId = try values.decodeIfPresent(UUID.self, forKey: .musicPublicId) ?? UUID(uuid: (0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0))
        musicPlaylistPublicIds = try values.decodeIfPresent([UUID].self, forKey: .musicPlaylistPublicIds) ?? []
    }
    public func encode(to encoder: any Encoder) throws {
        var c = encoder.container(keyedBy: CodingKeys.self)
        try c.encode(musicPublicId, forKey: .musicPublicId)
        try c.encode(musicPlaylistPublicIds, forKey: .musicPlaylistPublicIds)
    }

}

