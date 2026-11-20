import Foundation
import MizonAPI

public struct PersonMusicsResponse: IApiResponse {
    public var musics: [MusicTabMusicItemResponse]
    public var nextBeforeMusicPublicId: UUID?

    public init(musics: [MusicTabMusicItemResponse] = [],
                nextBeforeMusicPublicId: UUID? = nil) {
        self.musics = musics
        self.nextBeforeMusicPublicId = nextBeforeMusicPublicId
    }

    private enum CodingKeys: String, CodingKey {
        case musics
        case nextBeforeMusicPublicId
    }

    public init(from decoder: any Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        musics = try values.decodeIfPresent([MusicTabMusicItemResponse].self, forKey: .musics) ?? []
        nextBeforeMusicPublicId = try values.decodeIfPresent(UUID.self, forKey: .nextBeforeMusicPublicId)
    }
}
