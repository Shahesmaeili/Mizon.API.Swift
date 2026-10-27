import Foundation

public struct Endpoints: Sendable {
    public let baseURL: URL
    public init(baseURL: URL = URL(string: "https://localhost:5128")!) { self.baseURL = baseURL }
    public func url(_ path: String) -> URL { baseURL.appendingPathComponent(path) }
    public var mizonHubURL: URL { url("mizonHub") }
}
