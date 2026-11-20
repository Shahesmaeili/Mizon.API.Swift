import Foundation
import MizonAPI

public struct FeaturedPersonsResponse: IApiResponse {
    public var persons: [FeaturedPersonItem]

    public init(persons: [FeaturedPersonItem] = []) {
        self.persons = persons
    }

    private enum CodingKeys: String, CodingKey {
        case persons
    }

    public init(from decoder: any Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        persons = try values.decodeIfPresent([FeaturedPersonItem].self, forKey: .persons) ?? []
    }
}

public struct FeaturedPersonItem: Codable, Sendable {
    public var personPublicId: UUID
    public var sortOrder: Int16
    public var firstName: String
    public var lastName: String
    public var profileMediaPublicId: UUID?
    public var coverMediaPublicId: UUID?
    public var modelMediaPublicId: UUID?
    public var accentColor: String?
    public var modelAttribution: String?
    public var modelYawInDegrees: Float
    public var modelViewScale: Float
    public var modelVerticalFocus: Float
    public var followersCount: Int
    public var isFollowing: Bool
    public var canFollow: Bool
    public var musicsCount: Int
    public var genreTitle: String?
    public var persianGenreTitle: String?
    public var monthlyListenersCount: Int
    public var dailyPlays: [Int]
    public var latestMusics: [FeaturedPersonMusicItem]

    public init(personPublicId: UUID = UUID(uuid: (0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0)),
                sortOrder: Int16 = 0,
                firstName: String = "",
                lastName: String = "",
                profileMediaPublicId: UUID? = nil,
                coverMediaPublicId: UUID? = nil,
                modelMediaPublicId: UUID? = nil,
                accentColor: String? = nil,
                modelAttribution: String? = nil,
                modelYawInDegrees: Float = 0,
                modelViewScale: Float = 1,
                modelVerticalFocus: Float = 0,
                followersCount: Int = 0,
                isFollowing: Bool = false,
                canFollow: Bool = false,
                musicsCount: Int = 0,
                genreTitle: String? = nil,
                persianGenreTitle: String? = nil,
                monthlyListenersCount: Int = 0,
                dailyPlays: [Int] = [],
                latestMusics: [FeaturedPersonMusicItem] = []) {
        self.personPublicId = personPublicId
        self.sortOrder = sortOrder
        self.firstName = firstName
        self.lastName = lastName
        self.profileMediaPublicId = profileMediaPublicId
        self.coverMediaPublicId = coverMediaPublicId
        self.modelMediaPublicId = modelMediaPublicId
        self.accentColor = accentColor
        self.modelAttribution = modelAttribution
        self.modelYawInDegrees = modelYawInDegrees
        self.modelViewScale = modelViewScale
        self.modelVerticalFocus = modelVerticalFocus
        self.followersCount = followersCount
        self.isFollowing = isFollowing
        self.canFollow = canFollow
        self.musicsCount = musicsCount
        self.genreTitle = genreTitle
        self.persianGenreTitle = persianGenreTitle
        self.monthlyListenersCount = monthlyListenersCount
        self.dailyPlays = dailyPlays
        self.latestMusics = latestMusics
    }

    private enum CodingKeys: String, CodingKey {
        case personPublicId
        case sortOrder
        case firstName
        case lastName
        case profileMediaPublicId
        case coverMediaPublicId
        case modelMediaPublicId
        case accentColor
        case modelAttribution
        case modelYawInDegrees
        case modelViewScale
        case modelVerticalFocus
        case followersCount
        case isFollowing
        case canFollow
        case musicsCount
        case genreTitle
        case persianGenreTitle
        case monthlyListenersCount
        case dailyPlays
        case latestMusics
    }

    public init(from decoder: any Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        personPublicId = try values.decodeIfPresent(UUID.self, forKey: .personPublicId) ?? UUID(uuid: (0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0))
        sortOrder = try values.decodeIfPresent(Int16.self, forKey: .sortOrder) ?? 0
        firstName = try values.decodeIfPresent(String.self, forKey: .firstName) ?? ""
        lastName = try values.decodeIfPresent(String.self, forKey: .lastName) ?? ""
        profileMediaPublicId = try values.decodeIfPresent(UUID.self, forKey: .profileMediaPublicId)
        coverMediaPublicId = try values.decodeIfPresent(UUID.self, forKey: .coverMediaPublicId)
        modelMediaPublicId = try values.decodeIfPresent(UUID.self, forKey: .modelMediaPublicId)
        accentColor = try values.decodeIfPresent(String.self, forKey: .accentColor)
        modelAttribution = try values.decodeIfPresent(String.self, forKey: .modelAttribution)
        modelYawInDegrees = try values.decodeIfPresent(Float.self, forKey: .modelYawInDegrees) ?? 0
        modelViewScale = try values.decodeIfPresent(Float.self, forKey: .modelViewScale) ?? 1
        modelVerticalFocus = try values.decodeIfPresent(Float.self, forKey: .modelVerticalFocus) ?? 0
        followersCount = try values.decodeIfPresent(Int.self, forKey: .followersCount) ?? 0
        isFollowing = try values.decodeIfPresent(Bool.self, forKey: .isFollowing) ?? false
        canFollow = try values.decodeIfPresent(Bool.self, forKey: .canFollow) ?? false
        musicsCount = try values.decodeIfPresent(Int.self, forKey: .musicsCount) ?? 0
        genreTitle = try values.decodeIfPresent(String.self, forKey: .genreTitle)
        persianGenreTitle = try values.decodeIfPresent(String.self, forKey: .persianGenreTitle)
        monthlyListenersCount = try values.decodeIfPresent(Int.self, forKey: .monthlyListenersCount) ?? 0
        dailyPlays = try values.decodeIfPresent([Int].self, forKey: .dailyPlays) ?? []
        latestMusics = try values.decodeIfPresent([FeaturedPersonMusicItem].self, forKey: .latestMusics) ?? []
    }
}

public struct FeaturedPersonMusicItem: Codable, Sendable {
    public var publicId: UUID
    public var title: String
    public var persianTitle: String?
    public var coverMediaPublicId: UUID?
    public var duration: TimeSpan?
    public var likesCount: Int

    public init(publicId: UUID = UUID(uuid: (0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0)),
                title: String = "",
                persianTitle: String? = nil,
                coverMediaPublicId: UUID? = nil,
                duration: TimeSpan? = nil,
                likesCount: Int = 0) {
        self.publicId = publicId
        self.title = title
        self.persianTitle = persianTitle
        self.coverMediaPublicId = coverMediaPublicId
        self.duration = duration
        self.likesCount = likesCount
    }

    private enum CodingKeys: String, CodingKey {
        case publicId
        case title
        case persianTitle
        case coverMediaPublicId
        case duration
        case likesCount
    }

    public init(from decoder: any Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        publicId = try values.decodeIfPresent(UUID.self, forKey: .publicId) ?? UUID(uuid: (0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0))
        title = try values.decodeIfPresent(String.self, forKey: .title) ?? ""
        persianTitle = try values.decodeIfPresent(String.self, forKey: .persianTitle)
        coverMediaPublicId = try values.decodeIfPresent(UUID.self, forKey: .coverMediaPublicId)
        duration = try values.decodeIfPresent(TimeSpan.self, forKey: .duration)
        likesCount = try values.decodeIfPresent(Int.self, forKey: .likesCount) ?? 0
    }
}
