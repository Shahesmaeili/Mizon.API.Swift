import Foundation
import Testing
import MizonAPI
import MizonAPIClient

struct DotNetContractTests {
    @Test func everyModelRoundTripsAllDotNetFields() throws {
        let url = Bundle.module.url(forResource: "DotNetContracts", withExtension: "json", subdirectory: "Fixtures")!
        let fixtures = try JSONSerialization.jsonObject(with: Data(contentsOf: url)) as! [String: Any]
        func normalize(_ value: Any) -> Any {
            if let object = value as? [String: Any] { return object.mapValues(normalize) }
            if let array = value as? [Any] { return array.map(normalize) }
            if let string = value as? String, UUID(uuidString: string) != nil { return string.lowercased() }
            return value
        }
        func check<T: Codable>(_ type: T.Type, _ name: String) throws {
            let fixture = fixtures[name]!
            let data = try JSONSerialization.data(withJSONObject: fixture, options: [.sortedKeys])
            let model = try MizonJSON.decoder().decode(type, from: data)
            let actual = try JSONSerialization.jsonObject(with: MizonJSON.encoder().encode(model))
            #expect(NSDictionary(dictionary: normalize(actual) as! [String: Any]).isEqual(to: normalize(fixture) as! [String: Any]), "Wire fields differ for \(name)")
            // The source enables PropertyNameCaseInsensitive for all DTOs.
            func uppercase(_ value: Any) -> Any {
                if let object = value as? [String: Any] { return Dictionary(uniqueKeysWithValues: object.map { ($0.key.uppercased(), uppercase($0.value)) }) }
                if let array = value as? [Any] { return array.map(uppercase) }
                return value
            }
            _ = try MizonJSON.decoder().decode(type, from: JSONSerialization.data(withJSONObject: uppercase(fixture)))
        }
        try check(LoginRequest.self, "LoginRequest")
        try check(LogoutRequest.self, "LogoutRequest")
        try check(MeRequest.self, "MeRequest")
        try check(MediaRequest.self, "MediaRequest")
        try check(MusicAlbumMusicsRequest.self, "MusicAlbumMusicsRequest")
        try check(MusicCommentCreateRequest.self, "MusicCommentCreateRequest")
        try check(MusicCommentsRequest.self, "MusicCommentsRequest")
        try check(MusicContributorMusicsRequest.self, "MusicContributorMusicsRequest")
        try check(MusicContributorRequest.self, "MusicContributorRequest")
        try check(MusicFileRequest.self, "MusicFileRequest")
        try check(MusicFileWaveformRequest.self, "MusicFileWaveformRequest")
        try check(MusicGenreTypesRequest.self, "MusicGenreTypesRequest")
        try check(MusicLyricLineRequest.self, "MusicLyricLineRequest")
        try check(MusicLyricRequest.self, "MusicLyricRequest")
        try check(MusicPlaylistCreateRequest.self, "MusicPlaylistCreateRequest")
        try check(MusicPlaylistMembershipRequest.self, "MusicPlaylistMembershipRequest")
        try check(MusicPlaylistsRequest.self, "MusicPlaylistsRequest")
        try check(MusicReactionRequest.self, "MusicReactionRequest")
        try check(MusicReactionTypesRequest.self, "MusicReactionTypesRequest")
        try check(MusicReactionsRequest.self, "MusicReactionsRequest")
        try check(MusicRequest.self, "MusicRequest")
        try check(MusicStemMixRequest.self, "MusicStemMixRequest")
        try check(MusicViewRequest.self, "MusicViewRequest")
        try check(GlobalSearchRequest.self, "GlobalSearchRequest")
        try check(MusicStoriesRequest.self, "MusicStoriesRequest")
        try check(StoriesRequest.self, "StoriesRequest")
        try check(StoryCreateRequest.self, "StoryCreateRequest")
        try check(StoryWidgetCreateRequest.self, "StoryWidgetCreateRequest")
        try check(StoryLikeRequest.self, "StoryLikeRequest")
        try check(StoryRequest.self, "StoryRequest")
        try check(LoginResponse.self, "LoginResponse")
        try check(LogoutResponse.self, "LogoutResponse")
        try check(MeResponse.self, "MeResponse")
        try check(MeProfileResponse.self, "MeProfileResponse")
        try check(MediaResponse.self, "MediaResponse")
        try check(MusicCommentCreateResponse.self, "MusicCommentCreateResponse")
        try check(MusicCommentsResponse.self, "MusicCommentsResponse")
        try check(MusicCommentItemResponse.self, "MusicCommentItemResponse")
        try check(MusicContributorsResponse.self, "MusicContributorsResponse")
        try check(MusicContributorItemResponse.self, "MusicContributorItemResponse")
        try check(MusicFileResponse.self, "MusicFileResponse")
        try check(MusicFileWaveformResponse.self, "MusicFileWaveformResponse")
        try check(MusicLightingProfileResponse.self, "MusicLightingProfileResponse")
        try check(WaveformResponse.self, "WaveformResponse")
        try check(MusicGenreTypesResponse.self, "MusicGenreTypesResponse")
        try check(MusicGenreTypeItemResponse.self, "MusicGenreTypeItemResponse")
        try check(MusicLyricLineResponse.self, "MusicLyricLineResponse")
        try check(MusicLyricLineItemResponse.self, "MusicLyricLineItemResponse")
        try check(MusicLyricLineWordResponse.self, "MusicLyricLineWordResponse")
        try check(MusicLyricResponse.self, "MusicLyricResponse")
        try check(MusicLyricLanguageResponse.self, "MusicLyricLanguageResponse")
        try check(MusicPlaylistCreateResponse.self, "MusicPlaylistCreateResponse")
        try check(MusicPlaylistMembershipResponse.self, "MusicPlaylistMembershipResponse")
        try check(MusicPlaylistsResponse.self, "MusicPlaylistsResponse")
        try check(MusicPlaylistListItemResponse.self, "MusicPlaylistListItemResponse")
        try check(MusicReactionResponse.self, "MusicReactionResponse")
        try check(MusicReactionTypesResponse.self, "MusicReactionTypesResponse")
        try check(MusicReactionTypeItemResponse.self, "MusicReactionTypeItemResponse")
        try check(MusicReactionsResponse.self, "MusicReactionsResponse")
        try check(MusicReactionItemResponse.self, "MusicReactionItemResponse")
        try check(MusicResponse.self, "MusicResponse")
        try check(MusicLanguageResponse.self, "MusicLanguageResponse")
        try check(MusicAlbumResponse.self, "MusicAlbumResponse")
        try check(MusicLabelResponse.self, "MusicLabelResponse")
        try check(MusicGenreResponse.self, "MusicGenreResponse")
        try check(MusicCoverResponse.self, "MusicCoverResponse")
        try check(MusicStemMixResponse.self, "MusicStemMixResponse")
        try check(MusicTabMusicsResponse.self, "MusicTabMusicsResponse")
        try check(MusicTabMusicItemResponse.self, "MusicTabMusicItemResponse")
        try check(MusicTabContributorItemResponse.self, "MusicTabContributorItemResponse")
        try check(MusicViewResponse.self, "MusicViewResponse")
        try check(GlobalSearchItemResponse.self, "GlobalSearchItemResponse")
        try check(StoriesResponse.self, "StoriesResponse")
        try check(StoryListItemResponse.self, "StoryListItemResponse")
        try check(StoryResponse.self, "StoryResponse")
        try check(StoryWidgetResponse.self, "StoryWidgetResponse")
        try check(StoryMusicWidgetResponse.self, "StoryMusicWidgetResponse")
        try check(StoryClientWidgetResponse.self, "StoryClientWidgetResponse")
    }
}
