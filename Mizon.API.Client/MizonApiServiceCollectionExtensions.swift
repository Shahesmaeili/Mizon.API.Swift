import Foundation
import MizonAPI

/// Native composition root replacing .NET IServiceCollection registration.
public struct MizonServices: Sendable {
    public let api: MizonApi
    public let socket: MizonSocket
    public let mediaDownloader: MediaDownloader
    public let endpoints: Endpoints
    public init(baseURL: URL, cacheRoot: URL, session: URLSession = .shared) {
        endpoints = Endpoints(baseURL: baseURL)
        api = MizonApi(session: session)
        socket = MizonSocket(mizonApi: api, hubURL: endpoints.mizonHubURL)
        mediaDownloader = MediaDownloader(session: session, cacheRoot: cacheRoot)
    }
}
