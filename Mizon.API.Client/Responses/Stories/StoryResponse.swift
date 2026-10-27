import Foundation
import MizonAPI

public struct StoriesResponse: IApiResponse {
    public var stories: [StoryListItemResponse]

    public init(stories: [StoryListItemResponse] = []) {
        self.stories = stories
    }

    enum CodingKeys: String, CodingKey {
        case stories
    }

    public init(from decoder: any Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        stories = try values.decodeIfPresent([StoryListItemResponse].self, forKey: .stories) ?? []
    }
    public func encode(to encoder: any Encoder) throws {
        var c = encoder.container(keyedBy: CodingKeys.self)
        try c.encode(stories, forKey: .stories)
    }

}

public struct StoryListItemResponse: Codable, Sendable {
    public var publicId: UUID
    public var creatorFirstName: String
    public var creatorLastName: String
    public var creatorProfileMediaPublicId: UUID?
    public var previewMediaPublicId: UUID
    public var title: String?
    public var viewedByMe: Bool

    public init(publicId: UUID = UUID(uuid: (0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0)), creatorFirstName: String = "", creatorLastName: String = "", creatorProfileMediaPublicId: UUID? = nil, previewMediaPublicId: UUID = UUID(uuid: (0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0)), title: String? = nil, viewedByMe: Bool = false) {
        self.publicId = publicId
        self.creatorFirstName = creatorFirstName
        self.creatorLastName = creatorLastName
        self.creatorProfileMediaPublicId = creatorProfileMediaPublicId
        self.previewMediaPublicId = previewMediaPublicId
        self.title = title
        self.viewedByMe = viewedByMe
    }

    enum CodingKeys: String, CodingKey {
        case publicId
        case creatorFirstName
        case creatorLastName
        case creatorProfileMediaPublicId
        case previewMediaPublicId
        case title
        case viewedByMe
    }

    public init(from decoder: any Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        publicId = try values.decodeIfPresent(UUID.self, forKey: .publicId) ?? UUID(uuid: (0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0))
        creatorFirstName = try values.decodeIfPresent(String.self, forKey: .creatorFirstName) ?? ""
        creatorLastName = try values.decodeIfPresent(String.self, forKey: .creatorLastName) ?? ""
        creatorProfileMediaPublicId = try values.decodeIfPresent(UUID.self, forKey: .creatorProfileMediaPublicId)
        previewMediaPublicId = try values.decodeIfPresent(UUID.self, forKey: .previewMediaPublicId) ?? UUID(uuid: (0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0))
        title = try values.decodeIfPresent(String.self, forKey: .title)
        viewedByMe = try values.decodeIfPresent(Bool.self, forKey: .viewedByMe) ?? false
    }
    public func encode(to encoder: any Encoder) throws {
        var c = encoder.container(keyedBy: CodingKeys.self)
        try c.encode(publicId, forKey: .publicId)
        try c.encode(creatorFirstName, forKey: .creatorFirstName)
        try c.encode(creatorLastName, forKey: .creatorLastName)
        try c.encode(creatorProfileMediaPublicId, forKey: .creatorProfileMediaPublicId)
        try c.encode(previewMediaPublicId, forKey: .previewMediaPublicId)
        try c.encode(title, forKey: .title)
        try c.encode(viewedByMe, forKey: .viewedByMe)
    }

}

public struct StoryResponse: IApiResponse {
    public var publicId: UUID
    public var creatorClientPublicId: UUID
    public var creatorFirstName: String
    public var creatorLastName: String
    public var creatorUsername: String?
    public var creatorProfileMediaPublicId: UUID?
    public var storyContentTypePublicId: UUID
    public var storyContentTypeTitle: String
    public var storyContentTypePersianTitle: String?
    public var contentMediaPublicId: UUID
    public var previewMediaPublicId: UUID?
    public var title: String?
    public var expireDateTime: Date?
    public var viewedByMe: Bool
    public var likedByMe: Bool
    public var viewsCount: Int
    public var likesCount: Int
    public var widgets: [StoryWidgetResponse]

    public init(publicId: UUID = UUID(uuid: (0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0)), creatorClientPublicId: UUID = UUID(uuid: (0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0)), creatorFirstName: String = "", creatorLastName: String = "", creatorUsername: String? = nil, creatorProfileMediaPublicId: UUID? = nil, storyContentTypePublicId: UUID = UUID(uuid: (0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0)), storyContentTypeTitle: String = "", storyContentTypePersianTitle: String? = nil, contentMediaPublicId: UUID = UUID(uuid: (0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0)), previewMediaPublicId: UUID? = nil, title: String? = nil, expireDateTime: Date? = nil, viewedByMe: Bool = false, likedByMe: Bool = false, viewsCount: Int = 0, likesCount: Int = 0, widgets: [StoryWidgetResponse] = []) {
        self.publicId = publicId
        self.creatorClientPublicId = creatorClientPublicId
        self.creatorFirstName = creatorFirstName
        self.creatorLastName = creatorLastName
        self.creatorUsername = creatorUsername
        self.creatorProfileMediaPublicId = creatorProfileMediaPublicId
        self.storyContentTypePublicId = storyContentTypePublicId
        self.storyContentTypeTitle = storyContentTypeTitle
        self.storyContentTypePersianTitle = storyContentTypePersianTitle
        self.contentMediaPublicId = contentMediaPublicId
        self.previewMediaPublicId = previewMediaPublicId
        self.title = title
        self.expireDateTime = expireDateTime
        self.viewedByMe = viewedByMe
        self.likedByMe = likedByMe
        self.viewsCount = viewsCount
        self.likesCount = likesCount
        self.widgets = widgets
    }

    enum CodingKeys: String, CodingKey {
        case publicId
        case creatorClientPublicId
        case creatorFirstName
        case creatorLastName
        case creatorUsername
        case creatorProfileMediaPublicId
        case storyContentTypePublicId
        case storyContentTypeTitle
        case storyContentTypePersianTitle
        case contentMediaPublicId
        case previewMediaPublicId
        case title
        case expireDateTime
        case viewedByMe
        case likedByMe
        case viewsCount
        case likesCount
        case widgets
    }

    public init(from decoder: any Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        publicId = try values.decodeIfPresent(UUID.self, forKey: .publicId) ?? UUID(uuid: (0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0))
        creatorClientPublicId = try values.decodeIfPresent(UUID.self, forKey: .creatorClientPublicId) ?? UUID(uuid: (0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0))
        creatorFirstName = try values.decodeIfPresent(String.self, forKey: .creatorFirstName) ?? ""
        creatorLastName = try values.decodeIfPresent(String.self, forKey: .creatorLastName) ?? ""
        creatorUsername = try values.decodeIfPresent(String.self, forKey: .creatorUsername)
        creatorProfileMediaPublicId = try values.decodeIfPresent(UUID.self, forKey: .creatorProfileMediaPublicId)
        storyContentTypePublicId = try values.decodeIfPresent(UUID.self, forKey: .storyContentTypePublicId) ?? UUID(uuid: (0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0))
        storyContentTypeTitle = try values.decodeIfPresent(String.self, forKey: .storyContentTypeTitle) ?? ""
        storyContentTypePersianTitle = try values.decodeIfPresent(String.self, forKey: .storyContentTypePersianTitle)
        contentMediaPublicId = try values.decodeIfPresent(UUID.self, forKey: .contentMediaPublicId) ?? UUID(uuid: (0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0))
        previewMediaPublicId = try values.decodeIfPresent(UUID.self, forKey: .previewMediaPublicId)
        title = try values.decodeIfPresent(String.self, forKey: .title)
        expireDateTime = try values.decodeIfPresent(Date.self, forKey: .expireDateTime)
        viewedByMe = try values.decodeIfPresent(Bool.self, forKey: .viewedByMe) ?? false
        likedByMe = try values.decodeIfPresent(Bool.self, forKey: .likedByMe) ?? false
        viewsCount = try values.decodeIfPresent(Int.self, forKey: .viewsCount) ?? 0
        likesCount = try values.decodeIfPresent(Int.self, forKey: .likesCount) ?? 0
        widgets = try values.decodeIfPresent([StoryWidgetResponse].self, forKey: .widgets) ?? []
    }
    public func encode(to encoder: any Encoder) throws {
        var c = encoder.container(keyedBy: CodingKeys.self)
        try c.encode(publicId, forKey: .publicId)
        try c.encode(creatorClientPublicId, forKey: .creatorClientPublicId)
        try c.encode(creatorFirstName, forKey: .creatorFirstName)
        try c.encode(creatorLastName, forKey: .creatorLastName)
        try c.encode(creatorUsername, forKey: .creatorUsername)
        try c.encode(creatorProfileMediaPublicId, forKey: .creatorProfileMediaPublicId)
        try c.encode(storyContentTypePublicId, forKey: .storyContentTypePublicId)
        try c.encode(storyContentTypeTitle, forKey: .storyContentTypeTitle)
        try c.encode(storyContentTypePersianTitle, forKey: .storyContentTypePersianTitle)
        try c.encode(contentMediaPublicId, forKey: .contentMediaPublicId)
        try c.encode(previewMediaPublicId, forKey: .previewMediaPublicId)
        try c.encode(title, forKey: .title)
        try c.encode(expireDateTime, forKey: .expireDateTime)
        try c.encode(viewedByMe, forKey: .viewedByMe)
        try c.encode(likedByMe, forKey: .likedByMe)
        try c.encode(viewsCount, forKey: .viewsCount)
        try c.encode(likesCount, forKey: .likesCount)
        try c.encode(widgets, forKey: .widgets)
    }

}

public struct StoryWidgetResponse: Codable, Sendable {
    public var publicId: UUID
    public var storyWidgetTypePublicId: UUID
    public var storyWidgetStylePublicId: UUID
    public var x: Float
    public var y: Float
    public var width: Float
    public var height: Float
    public var rotation: Float
    public var zIndex: Int16
    public var music: StoryMusicWidgetResponse?
    public var client: StoryClientWidgetResponse?

    public init(publicId: UUID = UUID(uuid: (0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0)), storyWidgetTypePublicId: UUID = UUID(uuid: (0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0)), storyWidgetStylePublicId: UUID = UUID(uuid: (0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0)), x: Float = 0, y: Float = 0, width: Float = 0, height: Float = 0, rotation: Float = 0, zIndex: Int16 = 0, music: StoryMusicWidgetResponse? = nil, client: StoryClientWidgetResponse? = nil) {
        self.publicId = publicId
        self.storyWidgetTypePublicId = storyWidgetTypePublicId
        self.storyWidgetStylePublicId = storyWidgetStylePublicId
        self.x = x
        self.y = y
        self.width = width
        self.height = height
        self.rotation = rotation
        self.zIndex = zIndex
        self.music = music
        self.client = client
    }

    enum CodingKeys: String, CodingKey {
        case publicId
        case storyWidgetTypePublicId
        case storyWidgetStylePublicId
        case x
        case y
        case width
        case height
        case rotation
        case zIndex
        case music
        case client
    }

    public init(from decoder: any Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        publicId = try values.decodeIfPresent(UUID.self, forKey: .publicId) ?? UUID(uuid: (0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0))
        storyWidgetTypePublicId = try values.decodeIfPresent(UUID.self, forKey: .storyWidgetTypePublicId) ?? UUID(uuid: (0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0))
        storyWidgetStylePublicId = try values.decodeIfPresent(UUID.self, forKey: .storyWidgetStylePublicId) ?? UUID(uuid: (0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0))
        x = try values.decodeIfPresent(Float.self, forKey: .x) ?? 0
        y = try values.decodeIfPresent(Float.self, forKey: .y) ?? 0
        width = try values.decodeIfPresent(Float.self, forKey: .width) ?? 0
        height = try values.decodeIfPresent(Float.self, forKey: .height) ?? 0
        rotation = try values.decodeIfPresent(Float.self, forKey: .rotation) ?? 0
        zIndex = try values.decodeIfPresent(Int16.self, forKey: .zIndex) ?? 0
        music = try values.decodeIfPresent(StoryMusicWidgetResponse.self, forKey: .music)
        client = try values.decodeIfPresent(StoryClientWidgetResponse.self, forKey: .client)
    }
    public func encode(to encoder: any Encoder) throws {
        var c = encoder.container(keyedBy: CodingKeys.self)
        try c.encode(publicId, forKey: .publicId)
        try c.encode(storyWidgetTypePublicId, forKey: .storyWidgetTypePublicId)
        try c.encode(storyWidgetStylePublicId, forKey: .storyWidgetStylePublicId)
        try c.encode(x, forKey: .x)
        try c.encode(y, forKey: .y)
        try c.encode(width, forKey: .width)
        try c.encode(height, forKey: .height)
        try c.encode(rotation, forKey: .rotation)
        try c.encode(zIndex, forKey: .zIndex)
        try c.encode(music, forKey: .music)
        try c.encode(client, forKey: .client)
    }

}

public struct StoryMusicWidgetResponse: Codable, Sendable {
    public var musicPublicId: UUID
    public var title: String
    public var coverMediaPublicId: UUID?

    public init(musicPublicId: UUID = UUID(uuid: (0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0)), title: String = "", coverMediaPublicId: UUID? = nil) {
        self.musicPublicId = musicPublicId
        self.title = title
        self.coverMediaPublicId = coverMediaPublicId
    }

    enum CodingKeys: String, CodingKey {
        case musicPublicId
        case title
        case coverMediaPublicId
    }

    public init(from decoder: any Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        musicPublicId = try values.decodeIfPresent(UUID.self, forKey: .musicPublicId) ?? UUID(uuid: (0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0))
        title = try values.decodeIfPresent(String.self, forKey: .title) ?? ""
        coverMediaPublicId = try values.decodeIfPresent(UUID.self, forKey: .coverMediaPublicId)
    }
    public func encode(to encoder: any Encoder) throws {
        var c = encoder.container(keyedBy: CodingKeys.self)
        try c.encode(musicPublicId, forKey: .musicPublicId)
        try c.encode(title, forKey: .title)
        try c.encode(coverMediaPublicId, forKey: .coverMediaPublicId)
    }

}

public struct StoryClientWidgetResponse: Codable, Sendable {
    public var clientPublicId: UUID
    public var firstName: String
    public var lastName: String
    public var username: String?
    public var profileMediaPublicId: UUID?

    public init(clientPublicId: UUID = UUID(uuid: (0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0)), firstName: String = "", lastName: String = "", username: String? = nil, profileMediaPublicId: UUID? = nil) {
        self.clientPublicId = clientPublicId
        self.firstName = firstName
        self.lastName = lastName
        self.username = username
        self.profileMediaPublicId = profileMediaPublicId
    }

    enum CodingKeys: String, CodingKey {
        case clientPublicId
        case firstName
        case lastName
        case username
        case profileMediaPublicId
    }

    public init(from decoder: any Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        clientPublicId = try values.decodeIfPresent(UUID.self, forKey: .clientPublicId) ?? UUID(uuid: (0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0))
        firstName = try values.decodeIfPresent(String.self, forKey: .firstName) ?? ""
        lastName = try values.decodeIfPresent(String.self, forKey: .lastName) ?? ""
        username = try values.decodeIfPresent(String.self, forKey: .username)
        profileMediaPublicId = try values.decodeIfPresent(UUID.self, forKey: .profileMediaPublicId)
    }
    public func encode(to encoder: any Encoder) throws {
        var c = encoder.container(keyedBy: CodingKeys.self)
        try c.encode(clientPublicId, forKey: .clientPublicId)
        try c.encode(firstName, forKey: .firstName)
        try c.encode(lastName, forKey: .lastName)
        try c.encode(username, forKey: .username)
        try c.encode(profileMediaPublicId, forKey: .profileMediaPublicId)
    }

}

