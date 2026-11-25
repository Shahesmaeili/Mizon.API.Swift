import Foundation
import Testing
@testable import MizonAPI

struct AccountPresenceTests {
    @Test func accountSnapshotUsesTheHubFieldNames() throws {
        let id = UUID()
        let json = Data(#"{"clientPublicId":"\#(id.uuidString)","isOnline":true,"revision":4294967296}"#.utf8)
        let snapshot = try JSONDecoder().decode(ClientAccountPresenceResponse.self, from: json)
        #expect(snapshot == .init(clientPublicId: id, isOnline: true, revision: 4_294_967_296))
        let encoded = try JSONEncoder().encode(snapshot)
        let fields = try #require(JSONSerialization.jsonObject(with: encoded) as? [String: Any])
        #expect(Set(fields.keys) == ["clientPublicId", "isOnline", "revision"])
    }

    @Test func onlyNewerSnapshotsFromTheSameAccountCanChangeTheObservation() {
        let id = UUID()
        let otherID = UUID()
        var watch = AccountPresenceWatch(scope: .init(epoch: UUID(), clientPublicId: id, credentialGeneration: 1))

        let negativeRevision = watch.update(.init(clientPublicId: id, isOnline: true, revision: -1))
        let otherAccount = watch.update(.init(clientPublicId: otherID, isOnline: true, revision: 3))
        #expect(!negativeRevision)
        #expect(!otherAccount)
        #expect(watch.snapshot == nil)
        let initial = watch.update(.init(clientPublicId: id, isOnline: false, revision: 0))
        let online = watch.update(.init(clientPublicId: id, isOnline: true, revision: 2))
        let stale = watch.update(.init(clientPublicId: id, isOnline: false, revision: 1))
        let duplicate = watch.update(.init(clientPublicId: id, isOnline: false, revision: 2))
        #expect(initial && online)
        #expect(!stale && !duplicate)
        #expect(watch.snapshot == .init(clientPublicId: id, isOnline: true, revision: 2))
        let offline = watch.update(.init(clientPublicId: id, isOnline: false, revision: 3))
        #expect(offline)
        #expect(watch.snapshot?.isOnline == false)
    }

    @Test func anObservationCannotCrossCredentialsOrConnectionEpochs() async throws {
        let id = UUID()
        let epoch = UUID()
        let api = MizonApi()
        let bearer = "header.\(Data(#"{"sub":"\#(id.uuidString)"}"#.utf8).base64EncodedString()).signature"
        try await api.setToken(bearer)
        let before = await api.currentCredential()
        let watch = AccountPresenceWatch(scope: .init(epoch: epoch, clientPublicId: id,
                                                       credentialGeneration: before.generation))

        #expect(watch.matches(epoch: epoch, clientPublicId: MizonSocket.clientPublicId(from: before.token),
                              credentialGeneration: before.generation))
        #expect(!watch.matches(epoch: UUID(), clientPublicId: id, credentialGeneration: before.generation))
        await api.clearToken()
        let afterLogout = await api.currentCredential()
        #expect(!watch.matches(epoch: epoch, clientPublicId: MizonSocket.clientPublicId(from: afterLogout.token),
                               credentialGeneration: afterLogout.generation))
        try await api.setToken(bearer)
        let afterSignIn = await api.currentCredential()
        #expect(!watch.matches(epoch: epoch, clientPublicId: id, credentialGeneration: afterSignIn.generation))
    }

    @Test func watchingWhileDisconnectedDoesNotStartTransport() async throws {
        let socket = MizonSocket(mizonApi: MizonApi(), hubURL: try #require(URL(string: "https://example.test/mizonHub")))
        await #expect(throws: CancellationError.self) { try await socket.watchAccountPresence() }
        #expect(await socket.isConnected == false)
        #expect(await socket.accountPresence == nil)
        await socket.dispose()
    }
}
