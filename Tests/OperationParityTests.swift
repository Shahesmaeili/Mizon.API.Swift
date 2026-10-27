import Foundation
import Testing
import MizonAPI
import MizonAPIClient

struct OperationParityTests {
    @Test func everyOperationMatchesDotNetEndpointAndMethod() {
        let endpoints = Endpoints(baseURL: URL(string: "https://example.com/api")!)
        let op0 = LoginOperation(LoginRequest(), endpoints: endpoints).apiRequest
        #expect(op0.endpoint.path == "/api/Clients/Login")
        #expect(op0.httpMethod == .POST)
        let op1 = LogoutOperation(LogoutRequest(), endpoints: endpoints).apiRequest
        #expect(op1.endpoint.path == "/api/Clients/Logout")
        #expect(op1.httpMethod == .POST)
        let op2 = MeOperation(MeRequest(), endpoints: endpoints).apiRequest
        #expect(op2.endpoint.path == "/api/Clients/Me")
        #expect(op2.httpMethod == .GET)
        let op3 = MediaOperation(MediaRequest(), endpoints: endpoints).apiRequest
        #expect(op3.endpoint.path == "/api/Medias/Media")
        #expect(op3.httpMethod == .GET)
        let op4 = MusicAlbumMusicsOperation(MusicAlbumMusicsRequest(), endpoints: endpoints).apiRequest
        #expect(op4.endpoint.path == "/api/Musics/MusicAlbumMusics")
        #expect(op4.httpMethod == .GET)
        let op5 = MusicCommentCreateOperation(MusicCommentCreateRequest(), endpoints: endpoints).apiRequest
        #expect(op5.endpoint.path == "/api/Musics/MusicCommentCreate")
        #expect(op5.httpMethod == .POST)
        let op6 = MusicCommentsOperation(MusicCommentsRequest(), endpoints: endpoints).apiRequest
        #expect(op6.endpoint.path == "/api/Musics/MusicComments")
        #expect(op6.httpMethod == .GET)
        let op7 = MusicContributorMusicsOperation(MusicContributorMusicsRequest(), endpoints: endpoints).apiRequest
        #expect(op7.endpoint.path == "/api/Musics/MusicContributorMusics")
        #expect(op7.httpMethod == .GET)
        let op8 = MusicContributorsOperation(MusicContributorRequest(), endpoints: endpoints).apiRequest
        #expect(op8.endpoint.path == "/api/Musics/MusicContributors")
        #expect(op8.httpMethod == .GET)
        let op9 = MusicFileOperation(MusicFileRequest(), endpoints: endpoints).apiRequest
        #expect(op9.endpoint.path == "/api/Musics/MusicFile")
        #expect(op9.httpMethod == .GET)
        let op10 = MusicFileWaveformOperation(MusicFileWaveformRequest(), endpoints: endpoints).apiRequest
        #expect(op10.endpoint.path == "/api/Musics/MusicFileWaveform")
        #expect(op10.httpMethod == .GET)
        let op11 = MusicGenreTypesOperation(MusicGenreTypesRequest(), endpoints: endpoints).apiRequest
        #expect(op11.endpoint.path == "/api/Musics/MusicGenreTypes")
        #expect(op11.httpMethod == .GET)
        let op12 = MusicLyricLineOperation(MusicLyricLineRequest(), endpoints: endpoints).apiRequest
        #expect(op12.endpoint.path == "/api/Musics/MusicLyricLine")
        #expect(op12.httpMethod == .GET)
        let op13 = MusicLyricOperation(MusicLyricRequest(), endpoints: endpoints).apiRequest
        #expect(op13.endpoint.path == "/api/Musics/MusicLyric")
        #expect(op13.httpMethod == .GET)
        let op14 = MusicOperation(MusicRequest(), endpoints: endpoints).apiRequest
        #expect(op14.endpoint.path == "/api/Musics/Music")
        #expect(op14.httpMethod == .GET)
        let op15 = MusicPlaylistCreateOperation(MusicPlaylistCreateRequest(), endpoints: endpoints).apiRequest
        #expect(op15.endpoint.path == "/api/Musics/MusicPlaylistCreate")
        #expect(op15.httpMethod == .POST)
        let op16 = MusicPlaylistMembershipOperation(MusicPlaylistMembershipRequest(), endpoints: endpoints).apiRequest
        #expect(op16.endpoint.path == "/api/Musics/MusicPlaylistMembership")
        #expect(op16.httpMethod == .POST)
        let op17 = MusicPlaylistsOperation(MusicPlaylistsRequest(), endpoints: endpoints).apiRequest
        #expect(op17.endpoint.path == "/api/Musics/MusicPlaylists")
        #expect(op17.httpMethod == .POST)
        let op18 = MusicReactionOperation(MusicReactionRequest(), endpoints: endpoints).apiRequest
        #expect(op18.endpoint.path == "/api/Musics/MusicReaction")
        #expect(op18.httpMethod == .POST)
        let op19 = MusicReactionTypesOperation(MusicReactionTypesRequest(), endpoints: endpoints).apiRequest
        #expect(op19.endpoint.path == "/api/Musics/MusicReactionTypes")
        #expect(op19.httpMethod == .GET)
        let op20 = MusicReactionsOperation(MusicReactionsRequest(), endpoints: endpoints).apiRequest
        #expect(op20.endpoint.path == "/api/Musics/MusicReactions")
        #expect(op20.httpMethod == .GET)
        let op21 = MusicStemMixOperation(MusicStemMixRequest(), endpoints: endpoints).apiRequest
        #expect(op21.endpoint.path == "/api/Musics/MusicStemMix")
        #expect(op21.httpMethod == .GET)
        let op22 = MusicViewOperation(MusicViewRequest(), endpoints: endpoints).apiRequest
        #expect(op22.endpoint.path == "/api/Musics/MusicView")
        #expect(op22.httpMethod == .POST)
        let op23 = GlobalSearchOperation(GlobalSearchRequest(), endpoints: endpoints).apiRequest
        #expect(op23.endpoint.path == "/api/Search/Global")
        #expect(op23.httpMethod == .GET)
        let op24 = MusicStoriesOperation(MusicStoriesRequest(), endpoints: endpoints).apiRequest
        #expect(op24.endpoint.path == "/api/Stories/MusicStories")
        #expect(op24.httpMethod == .GET)
        let op25 = StoriesOperation(StoriesRequest(), endpoints: endpoints).apiRequest
        #expect(op25.endpoint.path == "/api/Stories/Stories")
        #expect(op25.httpMethod == .GET)
        let op26 = StoryCreateOperation(StoryCreateRequest(), endpoints: endpoints).apiRequest
        #expect(op26.endpoint.path == "/api/Stories/StoryCreate")
        #expect(op26.httpMethod == .POST)
        let op27 = StoryDetailsOperation(StoryRequest(), endpoints: endpoints).apiRequest
        #expect(op27.endpoint.path == "/api/Stories/StoryDetails")
        #expect(op27.httpMethod == .GET)
        let op28 = StoryLikeOperation(StoryLikeRequest(), endpoints: endpoints).apiRequest
        #expect(op28.endpoint.path == "/api/Stories/StoryLike")
        #expect(op28.httpMethod == .POST)
        let op29 = StoryViewOperation(StoryRequest(), endpoints: endpoints).apiRequest
        #expect(op29.endpoint.path == "/api/Stories/StoryView")
        #expect(op29.httpMethod == .POST)
    }
}
