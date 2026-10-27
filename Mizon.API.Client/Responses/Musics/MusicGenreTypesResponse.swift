import Foundation
import MizonAPI

public struct MusicGenreTypesResponse: IApiResponse {
    public var musicGenreTypes: [MusicGenreTypeItemResponse]

    public init(musicGenreTypes: [MusicGenreTypeItemResponse] = []) {
        self.musicGenreTypes = musicGenreTypes
    }

    enum CodingKeys: String, CodingKey {
        case musicGenreTypes
    }

    public init(from decoder: any Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        musicGenreTypes = try values.decodeIfPresent([MusicGenreTypeItemResponse].self, forKey: .musicGenreTypes) ?? []
    }
    public func encode(to encoder: any Encoder) throws {
        var c = encoder.container(keyedBy: CodingKeys.self)
        try c.encode(musicGenreTypes, forKey: .musicGenreTypes)
    }

}

public struct MusicGenreTypeItemResponse: Codable, Sendable {
    public var publicId: UUID
    public var title: String
    public var persianTitle: String?
    public var accentColorHex: String
    public var iconSymbol: String
    public var musicsCount: Int

    public init(publicId: UUID = UUID(uuid: (0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0)), title: String = "", persianTitle: String? = nil, accentColorHex: String = "", iconSymbol: String = "", musicsCount: Int = 0) {
        self.publicId = publicId
        self.title = title
        self.persianTitle = persianTitle
        self.accentColorHex = accentColorHex
        self.iconSymbol = iconSymbol
        self.musicsCount = musicsCount
    }

    enum CodingKeys: String, CodingKey {
        case publicId
        case title
        case persianTitle
        case accentColorHex
        case iconSymbol
        case musicsCount
    }

    public init(from decoder: any Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        publicId = try values.decodeIfPresent(UUID.self, forKey: .publicId) ?? UUID(uuid: (0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0))
        title = try values.decodeIfPresent(String.self, forKey: .title) ?? ""
        persianTitle = try values.decodeIfPresent(String.self, forKey: .persianTitle)
        accentColorHex = try values.decodeIfPresent(String.self, forKey: .accentColorHex) ?? ""
        iconSymbol = try values.decodeIfPresent(String.self, forKey: .iconSymbol) ?? ""
        musicsCount = try values.decodeIfPresent(Int.self, forKey: .musicsCount) ?? 0
    }
    public func encode(to encoder: any Encoder) throws {
        var c = encoder.container(keyedBy: CodingKeys.self)
        try c.encode(publicId, forKey: .publicId)
        try c.encode(title, forKey: .title)
        try c.encode(persianTitle, forKey: .persianTitle)
        try c.encode(accentColorHex, forKey: .accentColorHex)
        try c.encode(iconSymbol, forKey: .iconSymbol)
        try c.encode(musicsCount, forKey: .musicsCount)
    }

}

