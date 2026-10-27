public struct BaseApiResponse<Content: IApiResponse>: Codable, Sendable {
    public var content: Content?
    public var error: BaseApiError?
    public var isFromCache: Bool
    public var isSuccess: Bool { error == nil }
    public init(content: Content? = nil, error: BaseApiError? = nil, isFromCache: Bool = false) {
        self.content = content; self.error = error; self.isFromCache = isFromCache
    }
    enum CodingKeys: String, CodingKey { case content, error, isFromCache }
    public init(from decoder: any Decoder) throws {
        let c = try decoder.container(keyedBy: CodingKeys.self)
        content = try c.decodeIfPresent(Content.self, forKey: .content)
        error = try c.decodeIfPresent(BaseApiError.self, forKey: .error)
        isFromCache = try c.decodeIfPresent(Bool.self, forKey: .isFromCache) ?? false
    }
}
