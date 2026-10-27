public struct BaseApiError: Error, Codable, Sendable, Equatable {
    public var code: Int
    public var title: String
    public var details: String
    public var closeButtonText: String?
    public init(code: Int, title: String, details: String = "", closeButtonText: String? = nil) {
        self.code = code; self.title = title; self.details = details; self.closeButtonText = closeButtonText
    }
    enum CodingKeys: String, CodingKey { case code, title, details, closeButtonText }
    public init(from decoder: any Decoder) throws {
        let c = try decoder.container(keyedBy: CodingKeys.self)
        code = try c.decodeIfPresent(Int.self, forKey: .code) ?? 0
        title = try c.decodeIfPresent(String.self, forKey: .title) ?? ""
        details = try c.decodeIfPresent(String.self, forKey: .details) ?? ""
        closeButtonText = try c.decodeIfPresent(String.self, forKey: .closeButtonText)
    }
}
