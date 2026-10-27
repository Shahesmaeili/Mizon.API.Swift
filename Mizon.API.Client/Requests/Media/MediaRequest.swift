import Foundation
import MizonAPI

public struct MediaRequest: IApiRequest {
    public var mediaPublicId: UUID

    public init(mediaPublicId: UUID = UUID(uuid: (0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0))) {
        self.mediaPublicId = mediaPublicId
    }

    enum CodingKeys: String, CodingKey {
        case mediaPublicId
    }

    public init(from decoder: any Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        mediaPublicId = try values.decodeIfPresent(UUID.self, forKey: .mediaPublicId) ?? UUID(uuid: (0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0))
    }
    public func encode(to encoder: any Encoder) throws {
        var c = encoder.container(keyedBy: CodingKeys.self)
        try c.encode(mediaPublicId, forKey: .mediaPublicId)
    }

}

