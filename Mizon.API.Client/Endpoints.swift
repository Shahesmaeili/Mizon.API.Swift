import Foundation

public struct Endpoints: Sendable {
    public let baseURL: URL
    public init(baseURL: URL = URL(string: "https://localhost:5128")!) { self.baseURL = baseURL }
    public func url(_ path: String) -> URL { baseURL.appendingPathComponent(path) }
    public var mizonHubURL: URL { url("mizonHub") }
    public var clients: Clients { Clients(endpoints: self) }
    public struct Clients: Sendable {
        fileprivate let endpoints: Endpoints
        public var login: URL { endpoints.url("Clients/Login") }
        public var logout: URL { endpoints.url("Clients/Logout") }
        public var me: URL { endpoints.url("Clients/Me") }
    }
    public var musics: Musics { Musics(endpoints: self) }
    public struct Musics: Sendable {
        fileprivate let endpoints: Endpoints
        public var music: URL { endpoints.url("Musics/Music") }
        public var musicFileWaveform: URL { endpoints.url("Musics/MusicFileWaveform") }
        public var musicFile: URL { endpoints.url("Musics/MusicFile") }
        public var musicStemMix: URL { endpoints.url("Musics/MusicStemMix") }
        public var musicLyric: URL { endpoints.url("Musics/MusicLyric") }
        public var musicLyricLine: URL { endpoints.url("Musics/MusicLyricLine") }
        public var musicReaction: URL { endpoints.url("Musics/MusicReaction") }
        public var musicReactions: URL { endpoints.url("Musics/MusicReactions") }
        public var musicReactionTypes: URL { endpoints.url("Musics/MusicReactionTypes") }
        public var musicGenreTypes: URL { endpoints.url("Musics/MusicGenreTypes") }
        public var musicAlbumMusics: URL { endpoints.url("Musics/MusicAlbumMusics") }
        public var musicContributorMusics: URL { endpoints.url("Musics/MusicContributorMusics") }
        public var musicComments: URL { endpoints.url("Musics/MusicComments") }
        public var musicCommentCreate: URL { endpoints.url("Musics/MusicCommentCreate") }
        public var musicContributors: URL { endpoints.url("Musics/MusicContributors") }
        public var musicView: URL { endpoints.url("Musics/MusicView") }
        public var musicPlaylists: URL { endpoints.url("Musics/MusicPlaylists") }
        public var musicPlaylistMembership: URL { endpoints.url("Musics/MusicPlaylistMembership") }
        public var musicPlaylistCreate: URL { endpoints.url("Musics/MusicPlaylistCreate") }
    }
    public var medias: Medias { Medias(endpoints: self) }
    public struct Medias: Sendable {
        fileprivate let endpoints: Endpoints
        public var media: URL { endpoints.url("Medias/Media") }
    }
    public var stories: Stories { Stories(endpoints: self) }
    public struct Stories: Sendable {
        fileprivate let endpoints: Endpoints
        public var list: URL { endpoints.url("Stories/Stories") }
        public var musicStories: URL { endpoints.url("Stories/MusicStories") }
        public var storyDetails: URL { endpoints.url("Stories/StoryDetails") }
        public var storyView: URL { endpoints.url("Stories/StoryView") }
        public var storyLike: URL { endpoints.url("Stories/StoryLike") }
        public var storyCreate: URL { endpoints.url("Stories/StoryCreate") }
    }
    public var search: Search { Search(endpoints: self) }
    public struct Search: Sendable {
        fileprivate let endpoints: Endpoints
        public var global: URL { endpoints.url("Search/Global") }
    }
}
