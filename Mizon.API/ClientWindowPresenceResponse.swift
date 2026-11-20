import Foundation

public struct ClientWindowPresenceResponse: Codable, Sendable, Equatable {
    public let clientPublicId: UUID
    public let connectionId: String
    public let isOnline: Bool
    public let revision: Int64
}
