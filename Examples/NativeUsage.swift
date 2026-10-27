import Foundation
import MizonAPI
import MizonAPIClient

// This same service layer can be called from SwiftUI .task on iOS, macOS or watchOS.
func loadAccount(baseURL: URL, username: String, password: String) async throws -> MeResponse? {
    let api = MizonApi()
    let endpoints = Endpoints(baseURL: baseURL)
    let login = await api.sendRequest(LoginOperation(LoginRequest(username: username, password: password), endpoints: endpoints))
    if let error = login.error { throw error }
    let account = await api.sendRequest(MeOperation(MeRequest(), endpoints: endpoints))
    if let error = account.error { throw error }
    return account.content
}

func search(api: MizonApi, endpoints: Endpoints, query: String) async throws {
    for try await item in await api.sendStreamRequest(GlobalSearchOperation(GlobalSearchRequest(query: query), endpoints: endpoints)) {
        print(item.title ?? item.username ?? item.itemType)
    }
}

func observeMusic(api: MizonApi, endpoints: Endpoints, musicID: UUID) async throws {
    let socket = MizonSocket(mizonApi: api, hubURL: endpoints.mizonHubURL)
    let events = await socket.events()
    do {
        try await socket.joinEntity("Music", entityPublicId: musicID)
        try await socket.publishMusicPlayback(musicPublicId: musicID, position: TimeSpan(seconds: 30), isPlaying: true)
        for await event in events {
            if Task.isCancelled { break }
            if case let .musicListenersSnapshot(id, listeners) = event { print(id, listeners.count) }
        }
        await socket.dispose()
    } catch {
        await socket.dispose()
        throw error
    }
}
