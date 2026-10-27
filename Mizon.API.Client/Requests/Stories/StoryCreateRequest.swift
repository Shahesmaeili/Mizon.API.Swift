import Foundation
import MizonAPI

public struct StoryCreateRequest: IApiRequest {
    public var contentMediaPublicId: UUID
    public var previewMediaPublicId: UUID?
    public var storyContentTypePublicId: UUID
    public var title: String?
    public var expireDateTime: Date?
    public var widgets: [StoryWidgetCreateRequest]

    public init(contentMediaPublicId: UUID = UUID(uuid: (0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0)), previewMediaPublicId: UUID? = nil, storyContentTypePublicId: UUID = UUID(uuid: (0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0)), title: String? = nil, expireDateTime: Date? = nil, widgets: [StoryWidgetCreateRequest] = []) {
        self.contentMediaPublicId = contentMediaPublicId
        self.previewMediaPublicId = previewMediaPublicId
        self.storyContentTypePublicId = storyContentTypePublicId
        self.title = title
        self.expireDateTime = expireDateTime
        self.widgets = widgets
    }

    enum CodingKeys: String, CodingKey {
        case contentMediaPublicId
        case previewMediaPublicId
        case storyContentTypePublicId
        case title
        case expireDateTime
        case widgets
    }

    public init(from decoder: any Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        contentMediaPublicId = try values.decodeIfPresent(UUID.self, forKey: .contentMediaPublicId) ?? UUID(uuid: (0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0))
        previewMediaPublicId = try values.decodeIfPresent(UUID.self, forKey: .previewMediaPublicId)
        storyContentTypePublicId = try values.decodeIfPresent(UUID.self, forKey: .storyContentTypePublicId) ?? UUID(uuid: (0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0))
        title = try values.decodeIfPresent(String.self, forKey: .title)
        expireDateTime = try values.decodeIfPresent(Date.self, forKey: .expireDateTime)
        widgets = try values.decodeIfPresent([StoryWidgetCreateRequest].self, forKey: .widgets) ?? []
    }
    public func encode(to encoder: any Encoder) throws {
        var c = encoder.container(keyedBy: CodingKeys.self)
        try c.encode(contentMediaPublicId, forKey: .contentMediaPublicId)
        try c.encode(previewMediaPublicId, forKey: .previewMediaPublicId)
        try c.encode(storyContentTypePublicId, forKey: .storyContentTypePublicId)
        try c.encode(title, forKey: .title)
        try c.encode(expireDateTime, forKey: .expireDateTime)
        try c.encode(widgets, forKey: .widgets)
    }

}

public struct StoryWidgetCreateRequest: Codable, Sendable {
    public var storyWidgetTypePublicId: UUID
    public var storyWidgetStylePublicId: UUID
    public var x: Float
    public var y: Float
    public var width: Float
    public var height: Float
    public var rotation: Float
    public var zIndex: Int16
    public var musicPublicId: UUID?
    public var clientPublicId: UUID?

    public init(storyWidgetTypePublicId: UUID = UUID(uuid: (0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0)), storyWidgetStylePublicId: UUID = UUID(uuid: (0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0)), x: Float = 0, y: Float = 0, width: Float = 0, height: Float = 0, rotation: Float = 0, zIndex: Int16 = 0, musicPublicId: UUID? = nil, clientPublicId: UUID? = nil) {
        self.storyWidgetTypePublicId = storyWidgetTypePublicId
        self.storyWidgetStylePublicId = storyWidgetStylePublicId
        self.x = x
        self.y = y
        self.width = width
        self.height = height
        self.rotation = rotation
        self.zIndex = zIndex
        self.musicPublicId = musicPublicId
        self.clientPublicId = clientPublicId
    }

    enum CodingKeys: String, CodingKey {
        case storyWidgetTypePublicId
        case storyWidgetStylePublicId
        case x
        case y
        case width
        case height
        case rotation
        case zIndex
        case musicPublicId
        case clientPublicId
    }

    public init(from decoder: any Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        storyWidgetTypePublicId = try values.decodeIfPresent(UUID.self, forKey: .storyWidgetTypePublicId) ?? UUID(uuid: (0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0))
        storyWidgetStylePublicId = try values.decodeIfPresent(UUID.self, forKey: .storyWidgetStylePublicId) ?? UUID(uuid: (0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0))
        x = try values.decodeIfPresent(Float.self, forKey: .x) ?? 0
        y = try values.decodeIfPresent(Float.self, forKey: .y) ?? 0
        width = try values.decodeIfPresent(Float.self, forKey: .width) ?? 0
        height = try values.decodeIfPresent(Float.self, forKey: .height) ?? 0
        rotation = try values.decodeIfPresent(Float.self, forKey: .rotation) ?? 0
        zIndex = try values.decodeIfPresent(Int16.self, forKey: .zIndex) ?? 0
        musicPublicId = try values.decodeIfPresent(UUID.self, forKey: .musicPublicId)
        clientPublicId = try values.decodeIfPresent(UUID.self, forKey: .clientPublicId)
    }
    public func encode(to encoder: any Encoder) throws {
        var c = encoder.container(keyedBy: CodingKeys.self)
        try c.encode(storyWidgetTypePublicId, forKey: .storyWidgetTypePublicId)
        try c.encode(storyWidgetStylePublicId, forKey: .storyWidgetStylePublicId)
        try c.encode(x, forKey: .x)
        try c.encode(y, forKey: .y)
        try c.encode(width, forKey: .width)
        try c.encode(height, forKey: .height)
        try c.encode(rotation, forKey: .rotation)
        try c.encode(zIndex, forKey: .zIndex)
        try c.encode(musicPublicId, forKey: .musicPublicId)
        try c.encode(clientPublicId, forKey: .clientPublicId)
    }

}

