import Foundation
import MizonAPI

public struct ClientMoodRequest: IApiRequest {
    public var clientMoodTypePublicId: UUID?

    public init(clientMoodTypePublicId: UUID? = nil) {
        self.clientMoodTypePublicId = clientMoodTypePublicId
    }

    private enum CodingKeys: String, CodingKey {
        case clientMoodTypePublicId
    }

    public init(from decoder: any Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        clientMoodTypePublicId = try values.decodeIfPresent(UUID.self, forKey: .clientMoodTypePublicId)
    }
}
