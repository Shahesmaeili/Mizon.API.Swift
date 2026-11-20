import MizonAPI

public struct MusicLibraryOperation: APIOperation {
    public var apiRequest: MizonApiRequest<MusicLibraryRequest, MusicLibraryResponse>

    public init(_ request: MusicLibraryRequest, endpoints: Endpoints = Endpoints()) {
        apiRequest = MizonApiRequest(httpMethod: .POST, endpoint: endpoints.musics.musicLibrary, apiRequest: request)
        apiRequest.clientCacheStrategy = .disabled
    }
}
