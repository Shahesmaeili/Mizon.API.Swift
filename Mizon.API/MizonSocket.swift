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
public enum HubConnectionState: Sendable { case disconnected, connecting, connected, reconnecting }
public enum MizonSocketEvent: Sendable {
    case stateChanged(HubConnectionState)
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
    private func changeState(_ value: HubConnectionState) { state = value; emit(.stateChanged(value)) }
    private func configure() async {
        if let setupTask { await setupTask.value; return }
        let task = Task { [self, connection] in
            await connection.onClosed { [weak self] _ in await self?.changeState(.disconnected) }
            await connection.onReconnecting { [weak self] _ in await self?.changeState(.reconnecting) }
            await connection.onReconnected { [weak self] in await self?.reconnected() }
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
        changeState(.connected)
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
        generation = UUID(); startTask?.cancel(); startTask = nil
        await connection.stop(); changeState(.disconnected)
    }
    public func dispose() async {
        await stop()
        for c in subscribers.values { c.finish() }; subscribers.removeAll()
    }
}
