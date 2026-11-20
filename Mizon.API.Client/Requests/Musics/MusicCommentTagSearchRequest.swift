import Foundation
import MizonAPI

public struct MusicCommentTagSearchRequest: IApiRequest, APIQueryRequest {
    public var type: String
    public var query: String

    public init(type: String = "", query: String = "") {
        self.type = type
        self.query = query
    }

    public func queryItems() -> [URLQueryItem] {
        [.init(name: "Type", value: type), .init(name: "Query", value: query)]
    }
}
