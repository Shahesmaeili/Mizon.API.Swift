import Foundation

public struct ClientAccountPresenceResponse: Codable, Sendable, Equatable {
    public let clientPublicId: UUID
    public let isOnline: Bool
    public let revision: Int64

    public init(clientPublicId: UUID, isOnline: Bool, revision: Int64) {
        self.clientPublicId = clientPublicId
        self.isOnline = isOnline
        self.revision = revision
    }
}

struct AccountPresenceWatch {
    struct Scope: Equatable, Sendable {
        let epoch: UUID
        let clientPublicId: UUID
        let credentialGeneration: UInt64
    }

    let scope: Scope
    private(set) var snapshot: ClientAccountPresenceResponse?

    func matches(epoch: UUID, clientPublicId: UUID?, credentialGeneration: UInt64) -> Bool {
        scope.epoch == epoch && scope.clientPublicId == clientPublicId && scope.credentialGeneration == credentialGeneration
    }

    mutating func update(_ response: ClientAccountPresenceResponse) -> Bool {
        guard response.clientPublicId == scope.clientPublicId, response.revision >= 0,
              snapshot.map({ response.revision > $0.revision }) ?? true else { return false }
        snapshot = response
        return true
    }

    mutating func clearSnapshot() { snapshot = nil }
}
