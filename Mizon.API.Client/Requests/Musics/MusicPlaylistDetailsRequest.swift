import Foundation
import MizonAPI

public struct MusicPlaylistDetailsRequest: IApiRequest {
    public var musicPlaylistPublicId: UUID
    public var pageSize: Int
    public var cursor: String?

    public init(musicPlaylistPublicId: UUID = UUID(uuid: (0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0)),
                pageSize: Int = 30,
                cursor: String? = nil) {
        self.musicPlaylistPublicId = musicPlaylistPublicId
        self.pageSize = pageSize
        self.cursor = cursor
    }

    private enum CodingKeys: String, CodingKey {
        case musicPlaylistPublicId
        case pageSize
        case cursor
    }

    public init(from decoder: any Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        musicPlaylistPublicId = try values.decodeIfPresent(UUID.self, forKey: .musicPlaylistPublicId) ?? UUID(uuid: (0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0))
        pageSize = try values.decodeIfPresent(Int.self, forKey: .pageSize) ?? 30
        cursor = try values.decodeIfPresent(String.self, forKey: .cursor)
    }
}
