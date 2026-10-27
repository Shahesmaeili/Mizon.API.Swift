import Foundation
import MizonAPI

public struct GlobalSearchRequest: IApiRequest {
    public var query: String

    public init(query: String = "") {
        self.query = query
    }

    enum CodingKeys: String, CodingKey {
        case query
    }

    public init(from decoder: any Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        query = try values.decodeIfPresent(String.self, forKey: .query) ?? ""
    }
    public func encode(to encoder: any Encoder) throws {
        var c = encoder.container(keyedBy: CodingKeys.self)
        try c.encode(query, forKey: .query)
    }

}

