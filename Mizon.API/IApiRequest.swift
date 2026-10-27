import Foundation
public protocol IApiRequest: Codable, Sendable {}
public protocol APIQueryRequest: IApiRequest {
    func queryItems() throws -> [URLQueryItem]
}
