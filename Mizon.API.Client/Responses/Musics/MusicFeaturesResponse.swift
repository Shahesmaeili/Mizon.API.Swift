import Foundation
import MizonAPI

public struct MusicFeaturesResponse: IApiResponse {
    public var items: [MusicFeatureItemResponse]

    public init(items: [MusicFeatureItemResponse] = []) {
        self.items = items
    }

    private enum CodingKeys: String, CodingKey {
        case items
    }

    public init(from decoder: any Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        items = try values.decodeIfPresent([MusicFeatureItemResponse].self, forKey: .items) ?? []
    }
}

public struct MusicFeatureItemResponse: Codable, Sendable {
    public var publicId: UUID
    public var musicPublicId: UUID
    public var mediaPublicId: UUID
    public var previewMediaPublicId: UUID?
    public var contentTypeCode: String
    public var displaySeconds: Int
    public var title: String
    public var persianTitle: String?
    public var durationSeconds: Double?
    public var coverMediaPublicId: UUID?
    public var primaryAccentColor: String?
    public var likesCount: Int
    public var viewsCount: Int
    public var likedByMe: Bool
    public var contributors: [MusicFeatureContributorResponse]
    public var genres: [MusicFeatureGenreResponse]

    public init(publicId: UUID = UUID(uuid: (0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0)),
                musicPublicId: UUID = UUID(uuid: (0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0)),
                mediaPublicId: UUID = UUID(uuid: (0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0)),
                previewMediaPublicId: UUID? = nil,
                contentTypeCode: String = "",
                displaySeconds: Int = 0,
                title: String = "",
                persianTitle: String? = nil,
                durationSeconds: Double? = nil,
                coverMediaPublicId: UUID? = nil,
                primaryAccentColor: String? = nil,
                likesCount: Int = 0,
                viewsCount: Int = 0,
                likedByMe: Bool = false,
                contributors: [MusicFeatureContributorResponse] = [],
                genres: [MusicFeatureGenreResponse] = []) {
        self.publicId = publicId
        self.musicPublicId = musicPublicId
        self.mediaPublicId = mediaPublicId
        self.previewMediaPublicId = previewMediaPublicId
        self.contentTypeCode = contentTypeCode
        self.displaySeconds = displaySeconds
        self.title = title
        self.persianTitle = persianTitle
        self.durationSeconds = durationSeconds
        self.coverMediaPublicId = coverMediaPublicId
        self.primaryAccentColor = primaryAccentColor
        self.likesCount = likesCount
        self.viewsCount = viewsCount
        self.likedByMe = likedByMe
        self.contributors = contributors
        self.genres = genres
    }

    private enum CodingKeys: String, CodingKey {
        case publicId
        case musicPublicId
        case mediaPublicId
        case previewMediaPublicId
        case contentTypeCode
        case displaySeconds
        case title
        case persianTitle
        case durationSeconds
        case coverMediaPublicId
        case primaryAccentColor
        case likesCount
        case viewsCount
        case likedByMe
        case contributors
        case genres
    }

    public init(from decoder: any Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        publicId = try values.decodeIfPresent(UUID.self, forKey: .publicId) ?? UUID(uuid: (0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0))
        musicPublicId = try values.decodeIfPresent(UUID.self, forKey: .musicPublicId) ?? UUID(uuid: (0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0))
        mediaPublicId = try values.decodeIfPresent(UUID.self, forKey: .mediaPublicId) ?? UUID(uuid: (0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0))
        previewMediaPublicId = try values.decodeIfPresent(UUID.self, forKey: .previewMediaPublicId)
        contentTypeCode = try values.decodeIfPresent(String.self, forKey: .contentTypeCode) ?? ""
        displaySeconds = try values.decodeIfPresent(Int.self, forKey: .displaySeconds) ?? 0
        title = try values.decodeIfPresent(String.self, forKey: .title) ?? ""
        persianTitle = try values.decodeIfPresent(String.self, forKey: .persianTitle)
        durationSeconds = try values.decodeIfPresent(Double.self, forKey: .durationSeconds)
        coverMediaPublicId = try values.decodeIfPresent(UUID.self, forKey: .coverMediaPublicId)
        primaryAccentColor = try values.decodeIfPresent(String.self, forKey: .primaryAccentColor)
        likesCount = try values.decodeIfPresent(Int.self, forKey: .likesCount) ?? 0
        viewsCount = try values.decodeIfPresent(Int.self, forKey: .viewsCount) ?? 0
        likedByMe = try values.decodeIfPresent(Bool.self, forKey: .likedByMe) ?? false
        contributors = try values.decodeIfPresent([MusicFeatureContributorResponse].self, forKey: .contributors) ?? []
        genres = try values.decodeIfPresent([MusicFeatureGenreResponse].self, forKey: .genres) ?? []
    }
}

public struct MusicFeatureContributorResponse: Codable, Sendable {
    public var personPublicId: UUID
    public var firstName: String
    public var lastName: String
    public var profileMediaPublicId: UUID?

    public init(personPublicId: UUID = UUID(uuid: (0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0)),
                firstName: String = "",
                lastName: String = "",
                profileMediaPublicId: UUID? = nil) {
        self.personPublicId = personPublicId
        self.firstName = firstName
        self.lastName = lastName
        self.profileMediaPublicId = profileMediaPublicId
    }

    private enum CodingKeys: String, CodingKey {
        case personPublicId
        case firstName
        case lastName
        case profileMediaPublicId
    }

    public init(from decoder: any Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        personPublicId = try values.decodeIfPresent(UUID.self, forKey: .personPublicId) ?? UUID(uuid: (0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0))
        firstName = try values.decodeIfPresent(String.self, forKey: .firstName) ?? ""
        lastName = try values.decodeIfPresent(String.self, forKey: .lastName) ?? ""
        profileMediaPublicId = try values.decodeIfPresent(UUID.self, forKey: .profileMediaPublicId)
    }
}

public struct MusicFeatureGenreResponse: Codable, Sendable {
    public var publicId: UUID
    public var title: String
    public var persianTitle: String?

    public init(publicId: UUID = UUID(uuid: (0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0)),
                title: String = "",
                persianTitle: String? = nil) {
        self.publicId = publicId
        self.title = title
        self.persianTitle = persianTitle
    }

    private enum CodingKeys: String, CodingKey {
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
}
