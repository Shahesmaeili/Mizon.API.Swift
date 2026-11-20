import Foundation
import MizonAPI

public struct FollowingActivitiesResponse: IApiResponse {
    public var hasFollowings: Bool
    public var hasMore: Bool
    public var nextCursor: String?
    public var activities: [FollowingActivityItemResponse]

    public init(hasFollowings: Bool = false,
                hasMore: Bool = false,
                nextCursor: String? = nil,
                activities: [FollowingActivityItemResponse] = []) {
        self.hasFollowings = hasFollowings
        self.hasMore = hasMore
        self.nextCursor = nextCursor
        self.activities = activities
    }

    private enum CodingKeys: String, CodingKey {
        case hasFollowings
        case hasMore
        case nextCursor
        case activities
    }

    public init(from decoder: any Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        hasFollowings = try values.decodeIfPresent(Bool.self, forKey: .hasFollowings) ?? false
        hasMore = try values.decodeIfPresent(Bool.self, forKey: .hasMore) ?? false
        nextCursor = try values.decodeIfPresent(String.self, forKey: .nextCursor)
        activities = try values.decodeIfPresent([FollowingActivityItemResponse].self, forKey: .activities) ?? []
    }
}

public struct FollowingActivityItemResponse: Codable, Sendable {
    public var activityId: String
    public var activityType: String
    public var targetType: String
    public var domain: String
    public var createDateTime: Date
    public var clientPublicId: UUID
    public var firstName: String?
    public var lastName: String?
    public var nickName: String?
    public var username: String?
    public var profileMediaPublicId: UUID?
    public var musicPublicId: UUID?
    public var musicCommentPublicId: UUID?
    public var musicPlaylistPublicId: UUID?
    public var storyPublicId: UUID?
    public var storyViewedByMe: Bool
    public var storyContentTypeTitle: String?
    public var taggedMusicsCount: Int?
    public var title: String
    public var persianTitle: String?
    public var coverMediaPublicId: UUID?
    public var commentText: String?
    public var reactionEmoji: String?
    public var playlistMusicsCount: Int?

    public init(activityId: String = "",
                activityType: String = "",
                targetType: String = "",
                domain: String = "",
                createDateTime: Date = Date(timeIntervalSinceReferenceDate: 0),
                clientPublicId: UUID = UUID(uuid: (0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0)),
                firstName: String? = nil,
                lastName: String? = nil,
                nickName: String? = nil,
                username: String? = nil,
                profileMediaPublicId: UUID? = nil,
                musicPublicId: UUID? = nil,
                musicCommentPublicId: UUID? = nil,
                musicPlaylistPublicId: UUID? = nil,
                storyPublicId: UUID? = nil,
                storyViewedByMe: Bool = false,
                storyContentTypeTitle: String? = nil,
                taggedMusicsCount: Int? = nil,
                title: String = "",
                persianTitle: String? = nil,
                coverMediaPublicId: UUID? = nil,
                commentText: String? = nil,
                reactionEmoji: String? = nil,
                playlistMusicsCount: Int? = nil) {
        self.activityId = activityId
        self.activityType = activityType
        self.targetType = targetType
        self.domain = domain
        self.createDateTime = createDateTime
        self.clientPublicId = clientPublicId
        self.firstName = firstName
        self.lastName = lastName
        self.nickName = nickName
        self.username = username
        self.profileMediaPublicId = profileMediaPublicId
        self.musicPublicId = musicPublicId
        self.musicCommentPublicId = musicCommentPublicId
        self.musicPlaylistPublicId = musicPlaylistPublicId
        self.storyPublicId = storyPublicId
        self.storyViewedByMe = storyViewedByMe
        self.storyContentTypeTitle = storyContentTypeTitle
        self.taggedMusicsCount = taggedMusicsCount
        self.title = title
        self.persianTitle = persianTitle
        self.coverMediaPublicId = coverMediaPublicId
        self.commentText = commentText
        self.reactionEmoji = reactionEmoji
        self.playlistMusicsCount = playlistMusicsCount
    }

    private enum CodingKeys: String, CodingKey {
        case activityId
        case activityType
        case targetType
        case domain
        case createDateTime
        case clientPublicId
        case firstName
        case lastName
        case nickName
        case username
        case profileMediaPublicId
        case musicPublicId
        case musicCommentPublicId
        case musicPlaylistPublicId
        case storyPublicId
        case storyViewedByMe
        case storyContentTypeTitle
        case taggedMusicsCount
        case title
        case persianTitle
        case coverMediaPublicId
        case commentText
        case reactionEmoji
        case playlistMusicsCount
    }

    public init(from decoder: any Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        activityId = try values.decodeIfPresent(String.self, forKey: .activityId) ?? ""
        activityType = try values.decodeIfPresent(String.self, forKey: .activityType) ?? ""
        targetType = try values.decodeIfPresent(String.self, forKey: .targetType) ?? ""
        domain = try values.decodeIfPresent(String.self, forKey: .domain) ?? ""
        createDateTime = try values.decodeIfPresent(Date.self, forKey: .createDateTime) ?? Date(timeIntervalSinceReferenceDate: 0)
        clientPublicId = try values.decodeIfPresent(UUID.self, forKey: .clientPublicId) ?? UUID(uuid: (0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0))
        firstName = try values.decodeIfPresent(String.self, forKey: .firstName)
        lastName = try values.decodeIfPresent(String.self, forKey: .lastName)
        nickName = try values.decodeIfPresent(String.self, forKey: .nickName)
        username = try values.decodeIfPresent(String.self, forKey: .username)
        profileMediaPublicId = try values.decodeIfPresent(UUID.self, forKey: .profileMediaPublicId)
        musicPublicId = try values.decodeIfPresent(UUID.self, forKey: .musicPublicId)
        musicCommentPublicId = try values.decodeIfPresent(UUID.self, forKey: .musicCommentPublicId)
        musicPlaylistPublicId = try values.decodeIfPresent(UUID.self, forKey: .musicPlaylistPublicId)
        storyPublicId = try values.decodeIfPresent(UUID.self, forKey: .storyPublicId)
        storyViewedByMe = try values.decodeIfPresent(Bool.self, forKey: .storyViewedByMe) ?? false
        storyContentTypeTitle = try values.decodeIfPresent(String.self, forKey: .storyContentTypeTitle)
        taggedMusicsCount = try values.decodeIfPresent(Int.self, forKey: .taggedMusicsCount)
        title = try values.decodeIfPresent(String.self, forKey: .title) ?? ""
        persianTitle = try values.decodeIfPresent(String.self, forKey: .persianTitle)
        coverMediaPublicId = try values.decodeIfPresent(UUID.self, forKey: .coverMediaPublicId)
        commentText = try values.decodeIfPresent(String.self, forKey: .commentText)
        reactionEmoji = try values.decodeIfPresent(String.self, forKey: .reactionEmoji)
        playlistMusicsCount = try values.decodeIfPresent(Int.self, forKey: .playlistMusicsCount)
    }
}
