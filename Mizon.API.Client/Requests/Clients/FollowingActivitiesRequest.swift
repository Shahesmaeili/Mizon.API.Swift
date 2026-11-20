import Foundation
import MizonAPI

public struct FollowingActivitiesRequest: IApiRequest {
    public var scope: String
    public var pageSize: Int
    public var cursor: String?

    public init(scope: String = "",
                pageSize: Int = 20,
                cursor: String? = nil) {
        self.scope = scope
        self.pageSize = pageSize
        self.cursor = cursor
    }

    private enum CodingKeys: String, CodingKey {
        case scope
        case pageSize
        case cursor
    }

    public init(from decoder: any Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        scope = try values.decodeIfPresent(String.self, forKey: .scope) ?? ""
        pageSize = try values.decodeIfPresent(Int.self, forKey: .pageSize) ?? 20
        cursor = try values.decodeIfPresent(String.self, forKey: .cursor)
    }
}
