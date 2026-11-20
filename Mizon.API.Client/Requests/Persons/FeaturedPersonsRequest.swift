import Foundation
import MizonAPI

public struct FeaturedPersonsRequest: IApiRequest {
    public var typeCode: String?

    public init(typeCode: String? = nil) {
        self.typeCode = typeCode
    }

    private enum CodingKeys: String, CodingKey {
        case typeCode
    }

    public init(from decoder: any Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        typeCode = try values.decodeIfPresent(String.self, forKey: .typeCode)
    }
}
