import Foundation
import MizonAPI

public struct MusicFeaturesRequest: IApiRequest {
    public var limit: Int

    public init(limit: Int = 12) {
        self.limit = limit
    }

    private enum CodingKeys: String, CodingKey {
        case limit
    }

    public init(from decoder: any Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        limit = try values.decodeIfPresent(Int.self, forKey: .limit) ?? 12
    }
}
