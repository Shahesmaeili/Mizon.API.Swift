import Foundation
import MizonAPI

public struct PersonMusicsRequest: IApiRequest {
    public var personPublicId: UUID
    public var beforeMusicPublicId: UUID?

    public init(personPublicId: UUID = UUID(uuid: (0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0)),
                beforeMusicPublicId: UUID? = nil) {
        self.personPublicId = personPublicId
        self.beforeMusicPublicId = beforeMusicPublicId
    }

    private enum CodingKeys: String, CodingKey {
        case personPublicId
        case beforeMusicPublicId
    }

    public init(from decoder: any Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        personPublicId = try values.decodeIfPresent(UUID.self, forKey: .personPublicId) ?? UUID(uuid: (0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0))
        beforeMusicPublicId = try values.decodeIfPresent(UUID.self, forKey: .beforeMusicPublicId)
    }
}
