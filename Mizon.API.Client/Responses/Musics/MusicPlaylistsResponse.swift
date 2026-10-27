import Foundation
import MizonAPI

public struct MusicPlaylistsResponse: IApiResponse {
    public var musicPlaylists: [MusicPlaylistListItemResponse]

    public init(musicPlaylists: [MusicPlaylistListItemResponse] = []) {
        self.musicPlaylists = musicPlaylists
    }

    enum CodingKeys: String, CodingKey {
        case musicPlaylists
    }

    public init(from decoder: any Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        musicPlaylists = try values.decodeIfPresent([MusicPlaylistListItemResponse].self, forKey: .musicPlaylists) ?? []
    }
    public func encode(to encoder: any Encoder) throws {
        var c = encoder.container(keyedBy: CodingKeys.self)
        try c.encode(musicPlaylists, forKey: .musicPlaylists)
    }

}

public struct MusicPlaylistListItemResponse: Codable, Sendable {
    public var publicId: UUID
    public var title: String
    public var musicsCount: Int
    public var lastMusicCoverMediaPublicId: UUID?
    public var containsCurrentMusic: Bool

    public init(publicId: UUID = UUID(uuid: (0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0)), title: String = "", musicsCount: Int = 0, lastMusicCoverMediaPublicId: UUID? = nil, containsCurrentMusic: Bool = false) {
        self.publicId = publicId
        self.title = title
        self.musicsCount = musicsCount
        self.lastMusicCoverMediaPublicId = lastMusicCoverMediaPublicId
        self.containsCurrentMusic = containsCurrentMusic
    }

    enum CodingKeys: String, CodingKey {
        case publicId
        case title
        case musicsCount
        case lastMusicCoverMediaPublicId
        case containsCurrentMusic
    }

    public init(from decoder: any Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        publicId = try values.decodeIfPresent(UUID.self, forKey: .publicId) ?? UUID(uuid: (0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0))
        title = try values.decodeIfPresent(String.self, forKey: .title) ?? ""
        musicsCount = try values.decodeIfPresent(Int.self, forKey: .musicsCount) ?? 0
        lastMusicCoverMediaPublicId = try values.decodeIfPresent(UUID.self, forKey: .lastMusicCoverMediaPublicId)
        containsCurrentMusic = try values.decodeIfPresent(Bool.self, forKey: .containsCurrentMusic) ?? false
    }
    public func encode(to encoder: any Encoder) throws {
        var c = encoder.container(keyedBy: CodingKeys.self)
        try c.encode(publicId, forKey: .publicId)
        try c.encode(title, forKey: .title)
        try c.encode(musicsCount, forKey: .musicsCount)
        try c.encode(lastMusicCoverMediaPublicId, forKey: .lastMusicCoverMediaPublicId)
        try c.encode(containsCurrentMusic, forKey: .containsCurrentMusic)
    }

}

