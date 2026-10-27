import Foundation
import MizonAPI

public struct LoginResponse: IApiResponse {
    public var accessToken: String
    public var refreshToken: String
    public var sessionPublicId: UUID
    public var clientPublicId: UUID

    public init(accessToken: String = "", refreshToken: String = "", sessionPublicId: UUID = UUID(uuid: (0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0)), clientPublicId: UUID = UUID(uuid: (0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0))) {
        self.accessToken = accessToken
        self.refreshToken = refreshToken
        self.sessionPublicId = sessionPublicId
        self.clientPublicId = clientPublicId
    }

    enum CodingKeys: String, CodingKey {
        case accessToken
        case refreshToken
        case sessionPublicId
        case clientPublicId
    }

    public init(from decoder: any Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        accessToken = try values.decodeIfPresent(String.self, forKey: .accessToken) ?? ""
        refreshToken = try values.decodeIfPresent(String.self, forKey: .refreshToken) ?? ""
        sessionPublicId = try values.decodeIfPresent(UUID.self, forKey: .sessionPublicId) ?? UUID(uuid: (0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0))
        clientPublicId = try values.decodeIfPresent(UUID.self, forKey: .clientPublicId) ?? UUID(uuid: (0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0))
    }
    public func encode(to encoder: any Encoder) throws {
        var c = encoder.container(keyedBy: CodingKeys.self)
        try c.encode(accessToken, forKey: .accessToken)
        try c.encode(refreshToken, forKey: .refreshToken)
        try c.encode(sessionPublicId, forKey: .sessionPublicId)
        try c.encode(clientPublicId, forKey: .clientPublicId)
    }

}

