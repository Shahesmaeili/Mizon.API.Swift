import Foundation
import MizonAPI

public struct MeOperation: APIOperation {
    public var apiRequest: MizonApiRequest<MeRequest, MeResponse>

    public init(_ request: MeRequest, endpoints: Endpoints = Endpoints()) {
        apiRequest = MizonApiRequest(httpMethod: .GET, endpoint: endpoints.clients.me, apiRequest: request)
        apiRequest.clientCacheStrategy = .disabled
    }
}
