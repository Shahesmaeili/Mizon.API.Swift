import Foundation
import MizonAPI

public struct MusicLyricLineResponse: IApiResponse {
    public var musicLyricLines: [MusicLyricLineItemResponse]

    public init(musicLyricLines: [MusicLyricLineItemResponse] = []) {
        self.musicLyricLines = musicLyricLines
    }

    enum CodingKeys: String, CodingKey {
        case musicLyricLines
    }

    public init(from decoder: any Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        musicLyricLines = try values.decodeIfPresent([MusicLyricLineItemResponse].self, forKey: .musicLyricLines) ?? []
    }
    public func encode(to encoder: any Encoder) throws {
        var c = encoder.container(keyedBy: CodingKeys.self)
        try c.encode(musicLyricLines, forKey: .musicLyricLines)
    }

}

public struct MusicLyricLineItemResponse: Codable, Sendable {
    public var startTimeInMilliseconds: Int
    public var endTimeInMilliseconds: Int
    public var lineOrder: Int
    public var text: String
    public var musicLyricLineWords: [MusicLyricLineWordResponse]

    public init(startTimeInMilliseconds: Int = 0, endTimeInMilliseconds: Int = 0, lineOrder: Int = 0, text: String = "", musicLyricLineWords: [MusicLyricLineWordResponse] = []) {
        self.startTimeInMilliseconds = startTimeInMilliseconds
        self.endTimeInMilliseconds = endTimeInMilliseconds
        self.lineOrder = lineOrder
        self.text = text
        self.musicLyricLineWords = musicLyricLineWords
    }

    enum CodingKeys: String, CodingKey {
        case startTimeInMilliseconds
        case endTimeInMilliseconds
        case lineOrder
        case text
        case musicLyricLineWords
    }

    public init(from decoder: any Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        startTimeInMilliseconds = try values.decodeIfPresent(Int.self, forKey: .startTimeInMilliseconds) ?? 0
        endTimeInMilliseconds = try values.decodeIfPresent(Int.self, forKey: .endTimeInMilliseconds) ?? 0
        lineOrder = try values.decodeIfPresent(Int.self, forKey: .lineOrder) ?? 0
        text = try values.decodeIfPresent(String.self, forKey: .text) ?? ""
        musicLyricLineWords = try values.decodeIfPresent([MusicLyricLineWordResponse].self, forKey: .musicLyricLineWords) ?? []
    }
    public func encode(to encoder: any Encoder) throws {
        var c = encoder.container(keyedBy: CodingKeys.self)
        try c.encode(startTimeInMilliseconds, forKey: .startTimeInMilliseconds)
        try c.encode(endTimeInMilliseconds, forKey: .endTimeInMilliseconds)
        try c.encode(lineOrder, forKey: .lineOrder)
        try c.encode(text, forKey: .text)
        try c.encode(musicLyricLineWords, forKey: .musicLyricLineWords)
    }

}

public struct MusicLyricLineWordResponse: Codable, Sendable {
    public var startTimeInMilliseconds: Int
    public var endTimeInMilliseconds: Int
    public var wordOrder: Int
    public var text: String

    public init(startTimeInMilliseconds: Int = 0, endTimeInMilliseconds: Int = 0, wordOrder: Int = 0, text: String = "") {
        self.startTimeInMilliseconds = startTimeInMilliseconds
        self.endTimeInMilliseconds = endTimeInMilliseconds
        self.wordOrder = wordOrder
        self.text = text
    }

    enum CodingKeys: String, CodingKey {
        case startTimeInMilliseconds
        case endTimeInMilliseconds
        case wordOrder
        case text
    }

    public init(from decoder: any Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        startTimeInMilliseconds = try values.decodeIfPresent(Int.self, forKey: .startTimeInMilliseconds) ?? 0
        endTimeInMilliseconds = try values.decodeIfPresent(Int.self, forKey: .endTimeInMilliseconds) ?? 0
        wordOrder = try values.decodeIfPresent(Int.self, forKey: .wordOrder) ?? 0
        text = try values.decodeIfPresent(String.self, forKey: .text) ?? ""
    }
    public func encode(to encoder: any Encoder) throws {
        var c = encoder.container(keyedBy: CodingKeys.self)
        try c.encode(startTimeInMilliseconds, forKey: .startTimeInMilliseconds)
        try c.encode(endTimeInMilliseconds, forKey: .endTimeInMilliseconds)
        try c.encode(wordOrder, forKey: .wordOrder)
        try c.encode(text, forKey: .text)
    }

}

