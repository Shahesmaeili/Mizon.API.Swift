import Foundation
import MizonAPI

public struct PeerMediaManifestResponse: IApiResponse {
    public let fileHash: String
    public let fileSize: Int64
    public let chunkSize: Int
    /// The JSON representation is one Base64 string containing consecutive binary SHA-256 digests.
    public let pieceSha256: Data

    public init(fileHash: String, fileSize: Int64, chunkSize: Int, pieceSha256: Data) {
        self.fileHash = fileHash
        self.fileSize = fileSize
        self.chunkSize = chunkSize
        self.pieceSha256 = pieceSha256
    }
}
