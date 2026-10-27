public struct BaseApiRequest<Content: IApiRequest>: Codable, Sendable {
    public var content: Content?
    public init(content: Content? = nil) { self.content = content }
}
