import Foundation
import MizonAPI

public struct MusicStemMixResponse: IApiResponse {
    public var isAvailable: Bool
    public var musicFilePublicId: UUID?
    public var vocalsMediaPublicId: UUID?
    public var instrumentalMediaPublicId: UUID?

    public init(isAvailable: Bool = false, musicFilePublicId: UUID? = nil, vocalsMediaPublicId: UUID? = nil, instrumentalMediaPublicId: UUID? = nil) {
        self.isAvailable = isAvailable
        self.musicFilePublicId = musicFilePublicId
        self.vocalsMediaPublicId = vocalsMediaPublicId
        self.instrumentalMediaPublicId = instrumentalMediaPublicId
    }

    enum CodingKeys: String, CodingKey {
        case isAvailable
        case musicFilePublicId
        case vocalsMediaPublicId
        case instrumentalMediaPublicId
    }

    public init(from decoder: any Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        isAvailable = try values.decodeIfPresent(Bool.self, forKey: .isAvailable) ?? false
        musicFilePublicId = try values.decodeIfPresent(UUID.self, forKey: .musicFilePublicId)
        vocalsMediaPublicId = try values.decodeIfPresent(UUID.self, forKey: .vocalsMediaPublicId)
        instrumentalMediaPublicId = try values.decodeIfPresent(UUID.self, forKey: .instrumentalMediaPublicId)
    }
    public func encode(to encoder: any Encoder) throws {
        var c = encoder.container(keyedBy: CodingKeys.self)
        try c.encode(isAvailable, forKey: .isAvailable)
        try c.encode(musicFilePublicId, forKey: .musicFilePublicId)
        try c.encode(vocalsMediaPublicId, forKey: .vocalsMediaPublicId)
        try c.encode(instrumentalMediaPublicId, forKey: .instrumentalMediaPublicId)
    }

}

