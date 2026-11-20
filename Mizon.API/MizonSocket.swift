import Foundation
@preconcurrency import SignalRClient

public struct MusicListenerPresence: Codable, Sendable {
    public var clientPublicId: UUID
    public var firstName: String
    public var lastName: String
    public var username: String?
    public var profileMediaPublicId: UUID?
    public var positionMilliseconds: Int64
    public var isPlaying: Bool
    public var updatedAtUtc: Date
    public init(clientPublicId: UUID, firstName: String = "", lastName: String = "", username: String? = nil,
                profileMediaPublicId: UUID? = nil, positionMilliseconds: Int64 = 0, isPlaying: Bool = false,
                updatedAtUtc: Date = Date()) {
        self.clientPublicId = clientPublicId; self.firstName = firstName; self.lastName = lastName
        self.username = username; self.profileMediaPublicId = profileMediaPublicId
        self.positionMilliseconds = positionMilliseconds; self.isPlaying = isPlaying; self.updatedAtUtc = updatedAtUtc
    }
    enum CodingKeys: String, CodingKey {
        case clientPublicId, firstName, lastName, username, profileMediaPublicId, positionMilliseconds, isPlaying, updatedAtUtc
    }
    public init(from decoder: any Decoder) throws {
        let c = try decoder.container(keyedBy: CodingKeys.self)
        clientPublicId = try c.decode(UUID.self, forKey: .clientPublicId)
        firstName = try c.decodeIfPresent(String.self, forKey: .firstName) ?? ""
        lastName = try c.decodeIfPresent(String.self, forKey: .lastName) ?? ""
        username = try c.decodeIfPresent(String.self, forKey: .username)
        profileMediaPublicId = try c.decodeIfPresent(UUID.self, forKey: .profileMediaPublicId)
        positionMilliseconds = try c.decodeIfPresent(Int64.self, forKey: .positionMilliseconds) ?? 0
        isPlaying = try c.decodeIfPresent(Bool.self, forKey: .isPlaying) ?? false
        let value = try c.decode(String.self, forKey: .updatedAtUtc)
        let fractional = ISO8601DateFormatter(); fractional.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
        guard let date = fractional.date(from: value) ?? ISO8601DateFormatter().date(from: value) else {
            throw DecodingError.dataCorruptedError(forKey: .updatedAtUtc, in: c, debugDescription: "Invalid ISO8601 date")
        }
        updatedAtUtc = date
    }
    public func encode(to encoder: any Encoder) throws {
        var c = encoder.container(keyedBy: CodingKeys.self)
        try c.encode(clientPublicId, forKey: .clientPublicId)
        try c.encode(firstName, forKey: .firstName); try c.encode(lastName, forKey: .lastName)
        try c.encodeIfPresent(username, forKey: .username); try c.encodeIfPresent(profileMediaPublicId, forKey: .profileMediaPublicId)
        try c.encode(positionMilliseconds, forKey: .positionMilliseconds); try c.encode(isPlaying, forKey: .isPlaying)
        try c.encode(MizonJSON.iso8601String(from: updatedAtUtc), forKey: .updatedAtUtc)
    }

}
public struct OnlineClientCount: Codable, Sendable, Equatable {
    public let count: Int
    public let revision: Int64
}
public enum HubConnectionState: Sendable { case disconnected, connecting, connected, reconnecting }
public enum MizonSocketEvent: Sendable {
    case stateChanged(HubConnectionState)
    case onlineClientsChanged(OnlineClientCount?)
    case windowPresenceChanged(ClientWindowPresenceResponse?)
    case entityViewersCountChanged(entityType: String, entityId: UUID, count: Int)
    case musicListenersSnapshot(musicPublicId: UUID, listeners: [MusicListenerPresence])
    case musicListenerUpdated(musicPublicId: UUID, listener: MusicListenerPresence)
    case musicListenerRemoved(musicPublicId: UUID, clientPublicId: UUID)
    case error(String)
}

/// Uses Microsoft's official SignalRClient for negotiation, transports and reconnection.
public actor MizonSocket {
    private let api: MizonApi
    private let connection: HubConnection
    private var setupTask: Task<Void, Never>?
    private var startTask: Task<Void, any Error>?
    private var generation = UUID()
    private var connectionEpoch = UUID()
    private var presenceRevision: Int64 = 0
    private struct WindowPresenceIntent: Sendable {
        let clientID: UUID
        let active: Bool
        let revision: Int64
    }
    private var presenceIntent: WindowPresenceIntent?
    private var confirmedPresence: ClientWindowPresenceResponse?
    public private(set) var onlineClients: OnlineClientCount?
    public var windowPresence: ClientWindowPresenceResponse? {
        get async {
            let clientID = await currentClientPublicId
            guard isConnected, confirmedPresence?.clientPublicId == clientID else { return nil }
            return confirmedPresence
        }
    }

    private var currentEntity: (type: String, id: UUID)?
    private var subscribers: [UUID: AsyncStream<MizonSocketEvent>.Continuation] = [:]
    public private(set) var state: HubConnectionState = .disconnected
    public var isConnected: Bool { state == .connected }
    public init(mizonApi: MizonApi, hubURL: URL) {
        api = mizonApi
        var options = HttpConnectionOptions()
        options.accessTokenFactory = { await mizonApi.getToken() }
        options.timeout = 10
        connection = HubConnectionBuilder()
            .withUrl(url: hubURL.absoluteString, options: options)
            .withAutomaticReconnect()
            .build()
    }
    public var currentClientPublicId: UUID? {
        get async { Self.clientPublicId(from: await api.getToken()) }
    }
    /// Reads a JWT subject for display only; this does not authenticate or validate the JWT.
    public static func clientPublicId(from token: String?) -> UUID? {
        guard let token else { return nil }
        let parts = token.split(separator: ".", omittingEmptySubsequences: false)
        guard parts.count >= 2 else { return nil }
        var part = parts[1].replacingOccurrences(of: "-", with: "+").replacingOccurrences(of: "_", with: "/")
        part += String(repeating: "=", count: (4 - part.count % 4) % 4)
        guard let data = Data(base64Encoded: part), let object = try? JSONSerialization.jsonObject(with: data) as? [String: Any],
              let subject = object["sub"] as? String else { return nil }
        return UUID(uuidString: subject)
    }
    public func events() -> AsyncStream<MizonSocketEvent> {
        let id = UUID()
        let (stream, continuation) = AsyncStream<MizonSocketEvent>.makeStream(bufferingPolicy: .bufferingNewest(256))
        subscribers[id] = continuation
        continuation.yield(.stateChanged(state))
        continuation.onTermination = { @Sendable _ in Task { await self.removeSubscriber(id) } }
        return stream
    }
    private func removeSubscriber(_ id: UUID) { subscribers.removeValue(forKey: id) }
    private func emit(_ event: MizonSocketEvent) { for c in subscribers.values { c.yield(event) } }
    private func changeState(_ value: HubConnectionState) {
        guard state != value else { return }
        state = value
        if value != .connected {
            connectionEpoch = UUID()
            onlineClients = nil
            confirmedPresence = nil
            emit(.onlineClientsChanged(nil))
            emit(.windowPresenceChanged(nil))
        }
        emit(.stateChanged(value))
    }

    public func getOnlineFollowerCount() async throws -> Int {
        try await connection.invoke(method: "GetOnlineFollowerCount")
    }

    private func applyOnlineClientCount(_ count: OnlineClientCount) {
        guard isConnected, count.count >= 0, count.revision >= 0,
              onlineClients.map({ count.revision > $0.revision }) ?? true else { return }
        onlineClients = count
        emit(.onlineClientsChanged(count))
    }

    private func refreshAudience() async {
        let epoch = connectionEpoch
        // Older servers can still connect when these optional hub methods are unavailable.
        if let count: OnlineClientCount = try? await connection.invoke(method: "GetOnlineClientCount"),
           connectionEpoch == epoch {
            applyOnlineClientCount(count)
        }
    }

    public func setWindowPresence(isActive: Bool) async throws {
        try Task.checkCancellation()
        let clientID = await currentClientPublicId
        try Task.checkCancellation()
        presenceRevision += 1
        presenceIntent = clientID.map { .init(clientID: $0, active: isActive, revision: presenceRevision) }
        confirmedPresence = nil
        emit(.windowPresenceChanged(nil))
        guard let intent = presenceIntent, isConnected else { return }
        do {
            try await publishWindowPresence(intent)
        } catch is CancellationError {
            if presenceIntent?.revision == intent.revision {
                presenceRevision += 1
                let offline = WindowPresenceIntent(clientID: intent.clientID, active: false, revision: presenceRevision)
                presenceIntent = offline
                Task { try? await self.publishWindowPresence(offline) }
            }
            throw CancellationError()
        }
    }

    private func publishWindowPresence(_ intent: WindowPresenceIntent) async throws {
        let clientID = await currentClientPublicId
        guard isConnected, clientID == intent.clientID, presenceIntent?.revision == intent.revision else { return }
        let epoch = connectionEpoch
        let response: ClientWindowPresenceResponse = try await connection.invoke(
            method: "SetWindowPresence", arguments: intent.active, intent.revision)
        try Task.checkCancellation()
        let currentID = await currentClientPublicId
        guard isConnected, connectionEpoch == epoch, presenceIntent?.revision == intent.revision,
              response.revision == intent.revision, response.isOnline == intent.active,
              !response.connectionId.isEmpty, response.clientPublicId == intent.clientID,
              response.clientPublicId == currentID else { return }
        confirmedPresence = response
        emit(.windowPresenceChanged(response))
    }

    private func restorePresence() {
        if let intent = presenceIntent {
            Task { try? await self.publishWindowPresence(intent) }
        }
        Task { await self.refreshAudience() }
    }
    private func configure() async {
        if let setupTask { await setupTask.value; return }
        let task = Task { [self, connection] in
            await connection.onClosed { [weak self] _ in await self?.changeState(.disconnected) }
            await connection.onReconnecting { [weak self] _ in await self?.changeState(.reconnecting) }
            await connection.onReconnected { [weak self] in await self?.reconnected() }
            await connection.on("OnlineClientCountChanged") { [weak self] (count: OnlineClientCount) async -> Void in
                await self?.applyOnlineClientCount(count)
            }
            await connection.on("EntityViewersCountUpdated") { [weak self] (type: String, id: String, count: Int) async -> Void in
                guard let id = UUID(uuidString: id) else { return }
                await self?.emit(.entityViewersCountChanged(entityType: type, entityId: id, count: count))
            }
            await connection.on("MusicListenersSnapshot") { [weak self] (id: String, listeners: [MusicListenerPresence]) async -> Void in
                guard let id = UUID(uuidString: id) else { return }
                await self?.emit(.musicListenersSnapshot(musicPublicId: id, listeners: listeners))
            }
            await connection.on("MusicListenerUpdated") { [weak self] (id: String, listener: MusicListenerPresence) async -> Void in
                guard let id = UUID(uuidString: id) else { return }
                await self?.emit(.musicListenerUpdated(musicPublicId: id, listener: listener))
            }
            await connection.on("MusicListenerRemoved") { [weak self] (id: String, client: String) async -> Void in
                guard let id = UUID(uuidString: id), let client = UUID(uuidString: client) else { return }
                await self?.emit(.musicListenerRemoved(musicPublicId: id, clientPublicId: client))
            }

        }
        setupTask = task
        await task.value
    }
    private func reconnected() async {
        guard state == .reconnecting else { return }
        changeState(.connected)
        restorePresence()
        if let entity = currentEntity {
            do { try await connection.invoke(method: "JoinEntity", arguments: entity.type, entity.id) }
            catch { emit(.error(error.localizedDescription)) }
        }
    }
    public func start() async throws {
        if isConnected { return }
        if let startTask { try await startTask.value; return }
        let identity = generation
        let task = Task {
            await self.configure()
            try Task.checkCancellation()
            self.changeState(.connecting)
            try await self.connection.start()
            guard self.generation == identity else { throw CancellationError() }
            self.changeState(.connected)
            self.restorePresence()
        }
        startTask = task
        do { try await task.value; if generation == identity { startTask = nil } }
        catch { if generation == identity { startTask = nil; changeState(.disconnected) }; throw error }
    }
    public func joinEntity(_ entityType: String, entityPublicId: UUID) async throws {
        try await start()
        try await connection.invoke(method: "JoinEntity", arguments: entityType, entityPublicId)
        currentEntity = (entityType, entityPublicId)
    }
    public func leaveEntity() async throws {
        currentEntity = nil
        if isConnected { try await connection.invoke(method: "LeaveEntity") }
    }
    public func publishMusicPlayback(musicPublicId: UUID, position: TimeSpan, isPlaying: Bool) async throws {
        guard isConnected, let entity = currentEntity, entity.type.lowercased() == "music", entity.id == musicPublicId else { return }
        try await connection.invoke(method: "UpdateMusicPlayback", arguments: musicPublicId, max(0, position.ticks / 10_000), isPlaying)
    }
    public func registerDevice() async throws {
        try await connection.invoke(method: "RegisterDevice", arguments: await api.getToken() as Any)
    }
    public func unregisterDevice() async throws { if isConnected { try await connection.invoke(method: "UnregisterDevice") } }
    public func stop() async {
        generation = UUID()
        startTask?.cancel()
        startTask = nil
        presenceIntent = nil
        if state == .disconnected { emit(.stateChanged(.disconnected)) }
        else { changeState(.disconnected) }
        await connection.stop()
    }
    public func dispose() async {
        await stop()
        for c in subscribers.values { c.finish() }; subscribers.removeAll()
    }
}
