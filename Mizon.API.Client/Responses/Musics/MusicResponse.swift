import Foundation
import MizonAPI

public struct MusicResponse: IApiResponse {
    public var title: String
    public var persianTitle: String?
    public var releaseDateTime: Date?
    public var likedByMe: Bool
    public var likesCount: Int
    public var viewsCount: Int
    public var musicLanguages: [MusicLanguageResponse]
    public var musicGenres: [MusicGenreResponse]
    public var musicAlbum: MusicAlbumResponse?
    public var musicLabel: MusicLabelResponse?
    public var musicCover: MusicCoverResponse?

    public init(title: String = "", persianTitle: String? = nil, releaseDateTime: Date? = nil, likedByMe: Bool = false, likesCount: Int = 0, viewsCount: Int = 0, musicLanguages: [MusicLanguageResponse] = [], musicGenres: [MusicGenreResponse] = [], musicAlbum: MusicAlbumResponse? = nil, musicLabel: MusicLabelResponse? = nil, musicCover: MusicCoverResponse? = nil) {
        self.title = title
        self.persianTitle = persianTitle
        self.releaseDateTime = releaseDateTime
        self.likedByMe = likedByMe
        self.likesCount = likesCount
        self.viewsCount = viewsCount
        self.musicLanguages = musicLanguages
        self.musicGenres = musicGenres
        self.musicAlbum = musicAlbum
        self.musicLabel = musicLabel
        self.musicCover = musicCover
    }

    enum CodingKeys: String, CodingKey {
        case title
        case persianTitle
        case releaseDateTime
        case likedByMe
        case likesCount
        case viewsCount
        case musicLanguages
        case musicGenres
        case musicAlbum
        case musicLabel
        case musicCover
    }

    public init(from decoder: any Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        title = try values.decodeIfPresent(String.self, forKey: .title) ?? ""
        persianTitle = try values.decodeIfPresent(String.self, forKey: .persianTitle)
        releaseDateTime = try values.decodeIfPresent(Date.self, forKey: .releaseDateTime)
        likedByMe = try values.decodeIfPresent(Bool.self, forKey: .likedByMe) ?? false
        likesCount = try values.decodeIfPresent(Int.self, forKey: .likesCount) ?? 0
        viewsCount = try values.decodeIfPresent(Int.self, forKey: .viewsCount) ?? 0
        musicLanguages = try values.decodeIfPresent([MusicLanguageResponse].self, forKey: .musicLanguages) ?? []
        musicGenres = try values.decodeIfPresent([MusicGenreResponse].self, forKey: .musicGenres) ?? []
        musicAlbum = try values.decodeIfPresent(MusicAlbumResponse.self, forKey: .musicAlbum)
        musicLabel = try values.decodeIfPresent(MusicLabelResponse.self, forKey: .musicLabel)
        musicCover = try values.decodeIfPresent(MusicCoverResponse.self, forKey: .musicCover)
    }
    public func encode(to encoder: any Encoder) throws {
        var c = encoder.container(keyedBy: CodingKeys.self)
        try c.encode(title, forKey: .title)
        try c.encode(persianTitle, forKey: .persianTitle)
        try c.encode(releaseDateTime, forKey: .releaseDateTime)
        try c.encode(likedByMe, forKey: .likedByMe)
        try c.encode(likesCount, forKey: .likesCount)
        try c.encode(viewsCount, forKey: .viewsCount)
        try c.encode(musicLanguages, forKey: .musicLanguages)
        try c.encode(musicGenres, forKey: .musicGenres)
        try c.encode(musicAlbum, forKey: .musicAlbum)
        try c.encode(musicLabel, forKey: .musicLabel)
        try c.encode(musicCover, forKey: .musicCover)
    }

}

public struct MusicLanguageResponse: Codable, Sendable {
    public var publicId: UUID
    public var title: String
    public var persianTitle: String?

    public init(publicId: UUID = UUID(uuid: (0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0)), title: String = "", persianTitle: String? = nil) {
        self.publicId = publicId
        self.title = title
        self.persianTitle = persianTitle
    }

    enum CodingKeys: String, CodingKey {
        case publicId
        case title
        case persianTitle
    }

    public init(from decoder: any Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        publicId = try values.decodeIfPresent(UUID.self, forKey: .publicId) ?? UUID(uuid: (0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0))
        title = try values.decodeIfPresent(String.self, forKey: .title) ?? ""
        persianTitle = try values.decodeIfPresent(String.self, forKey: .persianTitle)
    }
    public func encode(to encoder: any Encoder) throws {
        var c = encoder.container(keyedBy: CodingKeys.self)
        try c.encode(publicId, forKey: .publicId)
        try c.encode(title, forKey: .title)
        try c.encode(persianTitle, forKey: .persianTitle)
    }

}

public struct MusicAlbumResponse: Codable, Sendable {
    public var publicId: UUID
    public var title: String
    public var persianTitle: String?

    public init(publicId: UUID = UUID(uuid: (0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0)), title: String = "", persianTitle: String? = nil) {
        self.publicId = publicId
        self.title = title
        self.persianTitle = persianTitle
    }

    enum CodingKeys: String, CodingKey {
        case publicId
        case title
        case persianTitle
    }

    public init(from decoder: any Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        publicId = try values.decodeIfPresent(UUID.self, forKey: .publicId) ?? UUID(uuid: (0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0))
        title = try values.decodeIfPresent(String.self, forKey: .title) ?? ""
        persianTitle = try values.decodeIfPresent(String.self, forKey: .persianTitle)
    }
    public func encode(to encoder: any Encoder) throws {
        var c = encoder.container(keyedBy: CodingKeys.self)
        try c.encode(publicId, forKey: .publicId)
        try c.encode(title, forKey: .title)
        try c.encode(persianTitle, forKey: .persianTitle)
    }

}

public struct MusicLabelResponse: Codable, Sendable {
    public var publicId: UUID
    public var title: String
    public var persianTitle: String?

    public init(publicId: UUID = UUID(uuid: (0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0)), title: String = "", persianTitle: String? = nil) {
        self.publicId = publicId
        self.title = title
        self.persianTitle = persianTitle
    }

    enum CodingKeys: String, CodingKey {
        case publicId
        case title
        case persianTitle
    }

    public init(from decoder: any Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        publicId = try values.decodeIfPresent(UUID.self, forKey: .publicId) ?? UUID(uuid: (0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0))
        title = try values.decodeIfPresent(String.self, forKey: .title) ?? ""
        persianTitle = try values.decodeIfPresent(String.self, forKey: .persianTitle)
    }
    public func encode(to encoder: any Encoder) throws {
        var c = encoder.container(keyedBy: CodingKeys.self)
        try c.encode(publicId, forKey: .publicId)
        try c.encode(title, forKey: .title)
        try c.encode(persianTitle, forKey: .persianTitle)
    }

}

public struct MusicGenreResponse: Codable, Sendable {
    public var publicId: UUID
    public var title: String
    public var persianTitle: String?

    public init(publicId: UUID = UUID(uuid: (0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0)), title: String = "", persianTitle: String? = nil) {
        self.publicId = publicId
        self.title = title
        self.persianTitle = persianTitle
    }

    enum CodingKeys: String, CodingKey {
        case publicId
        case title
        case persianTitle
    }

    public init(from decoder: any Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        publicId = try values.decodeIfPresent(UUID.self, forKey: .publicId) ?? UUID(uuid: (0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0))
        title = try values.decodeIfPresent(String.self, forKey: .title) ?? ""
        persianTitle = try values.decodeIfPresent(String.self, forKey: .persianTitle)
    }
    public func encode(to encoder: any Encoder) throws {
        var c = encoder.container(keyedBy: CodingKeys.self)
        try c.encode(publicId, forKey: .publicId)
        try c.encode(title, forKey: .title)
        try c.encode(persianTitle, forKey: .persianTitle)
    }

}

public struct MusicCoverResponse: Codable, Sendable {
    public var mediaPublicId: UUID
    public var fileSize: Int64
    public var blurhash: String
    public var width: Int16
    public var height: Int16
    public var primaryAccentColor: String

    public init(mediaPublicId: UUID = UUID(uuid: (0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0)), fileSize: Int64 = 0, blurhash: String = "", width: Int16 = 0, height: Int16 = 0, primaryAccentColor: String = "") {
        self.mediaPublicId = mediaPublicId
        self.fileSize = fileSize
        self.blurhash = blurhash
        self.width = width
        self.height = height
        self.primaryAccentColor = primaryAccentColor
    }

    enum CodingKeys: String, CodingKey {
        case mediaPublicId
        case fileSize
        case blurhash
        case width
        case height
        case primaryAccentColor
    }

    public init(from decoder: any Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        mediaPublicId = try values.decodeIfPresent(UUID.self, forKey: .mediaPublicId) ?? UUID(uuid: (0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0))
        fileSize = try values.decodeIfPresent(Int64.self, forKey: .fileSize) ?? 0
        blurhash = try values.decodeIfPresent(String.self, forKey: .blurhash) ?? ""
        width = try values.decodeIfPresent(Int16.self, forKey: .width) ?? 0
        height = try values.decodeIfPresent(Int16.self, forKey: .height) ?? 0
        primaryAccentColor = try values.decodeIfPresent(String.self, forKey: .primaryAccentColor) ?? ""
    }
    public func encode(to encoder: any Encoder) throws {
        var c = encoder.container(keyedBy: CodingKeys.self)
        try c.encode(mediaPublicId, forKey: .mediaPublicId)
        try c.encode(fileSize, forKey: .fileSize)
        try c.encode(blurhash, forKey: .blurhash)
        try c.encode(width, forKey: .width)
        try c.encode(height, forKey: .height)
        try c.encode(primaryAccentColor, forKey: .primaryAccentColor)
    }

}

