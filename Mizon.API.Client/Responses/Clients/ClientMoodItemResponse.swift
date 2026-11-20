import Foundation
import MizonAPI

public struct ClientMoodItemResponse: Codable, Sendable {
    public var publicId: UUID
    public var emoji: String
    public var title: String
    public var persianTitle: String?
    public var animationMediaPublicId: UUID
    public var previewMediaPublicId: UUID?
    public var effectMediaPublicIds: [UUID]

    public init(publicId: UUID = UUID(uuid: (0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0)),
                emoji: String = "",
                title: String = "",
                persianTitle: String? = nil,
                animationMediaPublicId: UUID = UUID(uuid: (0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0)),
                previewMediaPublicId: UUID? = nil,
                effectMediaPublicIds: [UUID] = []) {
        self.publicId = publicId
        self.emoji = emoji
        self.title = title
        self.persianTitle = persianTitle
        self.animationMediaPublicId = animationMediaPublicId
        self.previewMediaPublicId = previewMediaPublicId
        self.effectMediaPublicIds = effectMediaPublicIds
    }

    private enum CodingKeys: String, CodingKey {
        case publicId
        case emoji
        case title
        case persianTitle
        case animationMediaPublicId
        case previewMediaPublicId
        case effectMediaPublicIds
    }

    public init(from decoder: any Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        publicId = try values.decodeIfPresent(UUID.self, forKey: .publicId) ?? UUID(uuid: (0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0))
        emoji = try values.decodeIfPresent(String.self, forKey: .emoji) ?? ""
        title = try values.decodeIfPresent(String.self, forKey: .title) ?? ""
        persianTitle = try values.decodeIfPresent(String.self, forKey: .persianTitle)
        animationMediaPublicId = try values.decodeIfPresent(UUID.self, forKey: .animationMediaPublicId) ?? UUID(uuid: (0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0))
        previewMediaPublicId = try values.decodeIfPresent(UUID.self, forKey: .previewMediaPublicId)
        effectMediaPublicIds = try values.decodeIfPresent([UUID].self, forKey: .effectMediaPublicIds) ?? []
    }
}
