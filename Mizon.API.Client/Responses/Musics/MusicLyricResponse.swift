import Foundation
import MizonAPI

public struct MusicLyricResponse: IApiResponse {
    public var musicLyricLanguages: [MusicLyricLanguageResponse]

    public init(musicLyricLanguages: [MusicLyricLanguageResponse] = []) {
        self.musicLyricLanguages = musicLyricLanguages
    }

    enum CodingKeys: String, CodingKey {
        case musicLyricLanguages
    }

    public init(from decoder: any Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        musicLyricLanguages = try values.decodeIfPresent([MusicLyricLanguageResponse].self, forKey: .musicLyricLanguages) ?? []
    }
    public func encode(to encoder: any Encoder) throws {
        var c = encoder.container(keyedBy: CodingKeys.self)
        try c.encode(musicLyricLanguages, forKey: .musicLyricLanguages)
    }

}

public struct MusicLyricLanguageResponse: Codable, Sendable {
    public var musicLyricPublicId: UUID
    public var languagePublicId: UUID
    public var languageTitle: String
    public var languagePersianTitle: String?

    public init(musicLyricPublicId: UUID = UUID(uuid: (0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0)), languagePublicId: UUID = UUID(uuid: (0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0)), languageTitle: String = "", languagePersianTitle: String? = nil) {
        self.musicLyricPublicId = musicLyricPublicId
        self.languagePublicId = languagePublicId
        self.languageTitle = languageTitle
        self.languagePersianTitle = languagePersianTitle
    }

    enum CodingKeys: String, CodingKey {
        case musicLyricPublicId
        case languagePublicId
        case languageTitle
        case languagePersianTitle
    }

    public init(from decoder: any Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        musicLyricPublicId = try values.decodeIfPresent(UUID.self, forKey: .musicLyricPublicId) ?? UUID(uuid: (0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0))
        languagePublicId = try values.decodeIfPresent(UUID.self, forKey: .languagePublicId) ?? UUID(uuid: (0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0))
        languageTitle = try values.decodeIfPresent(String.self, forKey: .languageTitle) ?? ""
        languagePersianTitle = try values.decodeIfPresent(String.self, forKey: .languagePersianTitle)
    }
    public func encode(to encoder: any Encoder) throws {
        var c = encoder.container(keyedBy: CodingKeys.self)
        try c.encode(musicLyricPublicId, forKey: .musicLyricPublicId)
        try c.encode(languagePublicId, forKey: .languagePublicId)
        try c.encode(languageTitle, forKey: .languageTitle)
        try c.encode(languagePersianTitle, forKey: .languagePersianTitle)
    }

}

