import Foundation
import MizonAPI

public struct MusicTabMusicsResponse: IApiResponse {
    public var musics: [MusicTabMusicItemResponse]

    public init(musics: [MusicTabMusicItemResponse] = []) {
        self.musics = musics
    }

    enum CodingKeys: String, CodingKey {
        case musics
    }

    public init(from decoder: any Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        musics = try values.decodeIfPresent([MusicTabMusicItemResponse].self, forKey: .musics) ?? []
    }
    public func encode(to encoder: any Encoder) throws {
        var c = encoder.container(keyedBy: CodingKeys.self)
        try c.encode(musics, forKey: .musics)
    }

}

public struct MusicTabMusicItemResponse: Codable, Sendable {
    public var publicId: UUID
    public var title: String
    public var persianTitle: String?
    public var likesCount: Int
    public var coverMediaPublicId: UUID?
    public var contributors: [MusicTabContributorItemResponse]

    public init(publicId: UUID = UUID(uuid: (0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0)), title: String = "", persianTitle: String? = nil, likesCount: Int = 0, coverMediaPublicId: UUID? = nil, contributors: [MusicTabContributorItemResponse] = []) {
        self.publicId = publicId
        self.title = title
        self.persianTitle = persianTitle
        self.likesCount = likesCount
        self.coverMediaPublicId = coverMediaPublicId
        self.contributors = contributors
    }

    enum CodingKeys: String, CodingKey {
        case publicId
        case title
        case persianTitle
        case likesCount
        case coverMediaPublicId
        case contributors
    }

    public init(from decoder: any Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        publicId = try values.decodeIfPresent(UUID.self, forKey: .publicId) ?? UUID(uuid: (0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0))
        title = try values.decodeIfPresent(String.self, forKey: .title) ?? ""
        persianTitle = try values.decodeIfPresent(String.self, forKey: .persianTitle)
        likesCount = try values.decodeIfPresent(Int.self, forKey: .likesCount) ?? 0
        coverMediaPublicId = try values.decodeIfPresent(UUID.self, forKey: .coverMediaPublicId)
        contributors = try values.decodeIfPresent([MusicTabContributorItemResponse].self, forKey: .contributors) ?? []
    }
    public func encode(to encoder: any Encoder) throws {
        var c = encoder.container(keyedBy: CodingKeys.self)
        try c.encode(publicId, forKey: .publicId)
        try c.encode(title, forKey: .title)
        try c.encode(persianTitle, forKey: .persianTitle)
        try c.encode(likesCount, forKey: .likesCount)
        try c.encode(coverMediaPublicId, forKey: .coverMediaPublicId)
        try c.encode(contributors, forKey: .contributors)
    }

}

public struct MusicTabContributorItemResponse: Codable, Sendable {
    public var firstName: String
    public var lastName: String

    public init(firstName: String = "", lastName: String = "") {
        self.firstName = firstName
        self.lastName = lastName
    }

    enum CodingKeys: String, CodingKey {
        case firstName
        case lastName
    }

    public init(from decoder: any Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        firstName = try values.decodeIfPresent(String.self, forKey: .firstName) ?? ""
        lastName = try values.decodeIfPresent(String.self, forKey: .lastName) ?? ""
    }
    public func encode(to encoder: any Encoder) throws {
        var c = encoder.container(keyedBy: CodingKeys.self)
        try c.encode(firstName, forKey: .firstName)
        try c.encode(lastName, forKey: .lastName)
    }

}

