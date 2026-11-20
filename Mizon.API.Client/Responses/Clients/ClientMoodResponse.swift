import Foundation
import MizonAPI

public struct ClientMoodResponse: IApiResponse {
    public var currentMood: ClientMoodItemResponse?

    public init(currentMood: ClientMoodItemResponse? = nil) {
        self.currentMood = currentMood
    }

    private enum CodingKeys: String, CodingKey {
        case currentMood
    }

    public init(from decoder: any Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        currentMood = try values.decodeIfPresent(ClientMoodItemResponse.self, forKey: .currentMood)
    }
}
