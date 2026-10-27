import Foundation
import MizonAPI

public struct GlobalSearchOperation: APIStreamOperation {
    public var apiRequest: MizonApiStreamRequest<GlobalSearchRequest, GlobalSearchItemResponse>

    public init(_ request: GlobalSearchRequest, endpoints: Endpoints = Endpoints()) {
        apiRequest = MizonApiStreamRequest(httpMethod: .GET, endpoint: endpoints.url("Search/Global"), apiRequest: request)
    }
}
