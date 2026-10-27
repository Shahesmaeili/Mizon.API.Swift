import Foundation
import MizonAPI

public struct LoginRequest: IApiRequest {
    public var username: String?
    public var emailAddress: String?
    public var password: String

    public init(username: String? = nil, emailAddress: String? = nil, password: String = "") {
        self.username = username
        self.emailAddress = emailAddress
        self.password = password
    }

    enum CodingKeys: String, CodingKey {
        case username
        case emailAddress
        case password
    }

    public init(from decoder: any Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        username = try values.decodeIfPresent(String.self, forKey: .username)
        emailAddress = try values.decodeIfPresent(String.self, forKey: .emailAddress)
        password = try values.decodeIfPresent(String.self, forKey: .password) ?? ""
    }
    public func encode(to encoder: any Encoder) throws {
        var c = encoder.container(keyedBy: CodingKeys.self)
        try c.encode(username, forKey: .username)
        try c.encode(emailAddress, forKey: .emailAddress)
        try c.encode(password, forKey: .password)
    }

}

