import Foundation
import MizonAPI

public struct MediaResponse: IApiResponse {
    public var mediaPublicId: UUID
    public var totalChunks: Int
    public var chunkSize: Int
    public var fileHash: String
    public var fileName: String
    public var fileSize: Int64
    public var storagePath: String
    public var category: String

    public init(mediaPublicId: UUID = UUID(uuid: (0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0)), totalChunks: Int = 0, chunkSize: Int = 0, fileHash: String = "", fileName: String = "", fileSize: Int64 = 0, storagePath: String = "", category: String = "") {
        self.mediaPublicId = mediaPublicId
        self.totalChunks = totalChunks
        self.chunkSize = chunkSize
        self.fileHash = fileHash
        self.fileName = fileName
        self.fileSize = fileSize
        self.storagePath = storagePath
        self.category = category
    }

    enum CodingKeys: String, CodingKey {
        case mediaPublicId
        case totalChunks
        case chunkSize
        case fileHash
        case fileName
        case fileSize
        case storagePath
        case category
    }

    public init(from decoder: any Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        mediaPublicId = try values.decodeIfPresent(UUID.self, forKey: .mediaPublicId) ?? UUID(uuid: (0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0))
        totalChunks = try values.decodeIfPresent(Int.self, forKey: .totalChunks) ?? 0
        chunkSize = try values.decodeIfPresent(Int.self, forKey: .chunkSize) ?? 0
        fileHash = try values.decodeIfPresent(String.self, forKey: .fileHash) ?? ""
        fileName = try values.decodeIfPresent(String.self, forKey: .fileName) ?? ""
        fileSize = try values.decodeIfPresent(Int64.self, forKey: .fileSize) ?? 0
        storagePath = try values.decodeIfPresent(String.self, forKey: .storagePath) ?? ""
        category = try values.decodeIfPresent(String.self, forKey: .category) ?? ""
    }
    public func encode(to encoder: any Encoder) throws {
        var c = encoder.container(keyedBy: CodingKeys.self)
        try c.encode(mediaPublicId, forKey: .mediaPublicId)
        try c.encode(totalChunks, forKey: .totalChunks)
        try c.encode(chunkSize, forKey: .chunkSize)
        try c.encode(fileHash, forKey: .fileHash)
        try c.encode(fileName, forKey: .fileName)
        try c.encode(fileSize, forKey: .fileSize)
        try c.encode(storagePath, forKey: .storagePath)
        try c.encode(category, forKey: .category)
    }

}

