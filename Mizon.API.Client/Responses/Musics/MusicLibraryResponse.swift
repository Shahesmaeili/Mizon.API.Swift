import Foundation
import MizonAPI

public struct MusicLibraryResponse: IApiResponse {
    public var playlists: [MusicLibraryPlaylistItemResponse]
    public var totalPlaylistsCount: Int
    public var totalMusicsCount: Int64
    public var nextCursor: String?

    public init(playlists: [MusicLibraryPlaylistItemResponse] = [],
                totalPlaylistsCount: Int = 0,
                totalMusicsCount: Int64 = 0,
                nextCursor: String? = nil) {
        self.playlists = playlists
        self.totalPlaylistsCount = totalPlaylistsCount
        self.totalMusicsCount = totalMusicsCount
        self.nextCursor = nextCursor
    }

    private enum CodingKeys: String, CodingKey {
        case playlists
        case totalPlaylistsCount
        case totalMusicsCount
        case nextCursor
    }

    public init(from decoder: any Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        playlists = try values.decodeIfPresent([MusicLibraryPlaylistItemResponse].self, forKey: .playlists) ?? []
        totalPlaylistsCount = try values.decodeIfPresent(Int.self, forKey: .totalPlaylistsCount) ?? 0
        totalMusicsCount = try values.decodeIfPresent(Int64.self, forKey: .totalMusicsCount) ?? 0
        nextCursor = try values.decodeIfPresent(String.self, forKey: .nextCursor)
    }
}

public struct MusicLibraryPlaylistItemResponse: Codable, Sendable {
    public var publicId: UUID
    public var title: String
    public var musicsCount: Int
    public var lastMusicCoverMediaPublicId: UUID?
    public var lastUpdatedAt: Date

    public init(publicId: UUID = UUID(uuid: (0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0)),
                title: String = "",
                musicsCount: Int = 0,
                lastMusicCoverMediaPublicId: UUID? = nil,
                lastUpdatedAt: Date = Date(timeIntervalSinceReferenceDate: 0)) {
        self.publicId = publicId
        self.title = title
        self.musicsCount = musicsCount
        self.lastMusicCoverMediaPublicId = lastMusicCoverMediaPublicId
        self.lastUpdatedAt = lastUpdatedAt
    }

    private enum CodingKeys: String, CodingKey {
        case publicId
        case title
        case musicsCount
        case lastMusicCoverMediaPublicId
        case lastUpdatedAt
    }

    public init(from decoder: any Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        publicId = try values.decodeIfPresent(UUID.self, forKey: .publicId) ?? UUID(uuid: (0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0))
        title = try values.decodeIfPresent(String.self, forKey: .title) ?? ""
        musicsCount = try values.decodeIfPresent(Int.self, forKey: .musicsCount) ?? 0
        lastMusicCoverMediaPublicId = try values.decodeIfPresent(UUID.self, forKey: .lastMusicCoverMediaPublicId)
        lastUpdatedAt = try values.decodeIfPresent(Date.self, forKey: .lastUpdatedAt) ?? Date(timeIntervalSinceReferenceDate: 0)
    }
}
