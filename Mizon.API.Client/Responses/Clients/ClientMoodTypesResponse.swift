import Foundation
import MizonAPI

public struct ClientMoodTypesResponse: IApiResponse {
    public var items: [ClientMoodItemResponse]

    public init(items: [ClientMoodItemResponse] = []) {
        self.items = items
    }

    private enum CodingKeys: String, CodingKey {
        case items
    }

    public init(from decoder: any Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        items = try values.decodeIfPresent([ClientMoodItemResponse].self, forKey: .items) ?? []
    }
}
