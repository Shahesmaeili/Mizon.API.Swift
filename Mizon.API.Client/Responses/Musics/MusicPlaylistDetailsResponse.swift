import Foundation
import MizonAPI

public struct MusicPlaylistDetailsResponse: IApiResponse {
    public var publicId: UUID
    public var title: String
    public var isOwner: Bool
    public var musicsCount: Int
    public var musics: [MusicTabMusicItemResponse]
    public var nextCursor: String?

    public init(publicId: UUID = UUID(uuid: (0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0)),
                title: String = "",
                isOwner: Bool = false,
                musicsCount: Int = 0,
                musics: [MusicTabMusicItemResponse] = [],
                nextCursor: String? = nil) {
        self.publicId = publicId
        self.title = title
        self.isOwner = isOwner
        self.musicsCount = musicsCount
        self.musics = musics
        self.nextCursor = nextCursor
    }

    private enum CodingKeys: String, CodingKey {
        case publicId
        case title
        case isOwner
        case musicsCount
        case musics
        case nextCursor
    }

    public init(from decoder: any Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        publicId = try values.decodeIfPresent(UUID.self, forKey: .publicId) ?? UUID(uuid: (0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0))
        title = try values.decodeIfPresent(String.self, forKey: .title) ?? ""
        isOwner = try values.decodeIfPresent(Bool.self, forKey: .isOwner) ?? false
        musicsCount = try values.decodeIfPresent(Int.self, forKey: .musicsCount) ?? 0
        musics = try values.decodeIfPresent([MusicTabMusicItemResponse].self, forKey: .musics) ?? []
        nextCursor = try values.decodeIfPresent(String.self, forKey: .nextCursor)
    }
}
