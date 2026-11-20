import Foundation
import MizonAPI

public struct MusicLibraryRequest: IApiRequest {
    public var pageSize: Int
    public var cursor: String?

    public init(pageSize: Int = 5,
                cursor: String? = nil) {
        self.pageSize = pageSize
        self.cursor = cursor
    }

    private enum CodingKeys: String, CodingKey {
        case pageSize
        case cursor
    }

    public init(from decoder: any Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        pageSize = try values.decodeIfPresent(Int.self, forKey: .pageSize) ?? 5
        cursor = try values.decodeIfPresent(String.self, forKey: .cursor)
    }
}
