import Foundation
import CryptoKit

/// An immutable media identity and piece table. Only obtain production tables from a trusted origin.
public struct VerifiedMediaManifest: Sendable, Equatable {
    public static let maximumPieceSize = 4 * 1024 * 1024
    public static let maximumPieces = 65_536
    private static let digestSize = 32
    static let maximumEnvelopeBytes = ((maximumPieces * digestSize + 2) / 3) * 4 + 16 * 1024

    public let fileHash: String
    public let rawFileHash: Data
    public let fileSize: Int64
    public let chunkSize: Int
    public let pieceCount: Int
    private let pieceSha256: Data

    public init?(fileHash: String, fileSize: Int64, chunkSize: Int, pieceSha256: Data) {
        guard let rawFileHash = Self.hashBytes(fileHash), let count = Self.pieceCount(fileSize: fileSize, chunkSize: chunkSize),
              pieceSha256.count == count * Self.digestSize else { return nil }
        self.fileHash = fileHash.lowercased()
        self.rawFileHash = rawFileHash
        self.fileSize = fileSize
        self.chunkSize = chunkSize
        self.pieceCount = count
        self.pieceSha256 = Data(pieceSha256)
    }

    public func matches(_ media: MediaResponse) -> Bool {
        fileSize == media.fileSize && chunkSize == media.chunkSize && pieceCount == media.totalChunks &&
            fileHash.caseInsensitiveCompare(media.fileHash) == .orderedSame
    }

    public func range(for index: Int) -> ClosedRange<Int64>? {
        guard index >= 0, index < pieceCount else { return nil }
        let start = Int64(index) * Int64(chunkSize)
        let length = min(Int64(chunkSize), fileSize - start)
        return start...(start + length - 1)
    }

    public func pieceLength(at index: Int) -> Int? {
        guard let range = range(for: index) else { return nil }
        return Int(range.upperBound - range.lowerBound + 1)
    }

    public func digest(at index: Int) -> Data? {
        guard index >= 0, index < pieceCount else { return nil }
        let start = pieceSha256.startIndex + index * Self.digestSize
        return pieceSha256.subdata(in: start..<(start + Self.digestSize))
    }

    public func verify(_ bytes: Data, at index: Int) -> Bool {
        guard pieceLength(at: index) == bytes.count, let digest = digest(at: index) else { return false }
        return SHA256.hash(data: bytes).elementsEqual(digest)
    }

    static func supports(_ media: MediaResponse) -> Bool {
        pieceCount(fileSize: media.fileSize, chunkSize: media.chunkSize) == media.totalChunks &&
            hashBytes(media.fileHash) != nil
    }

    private static func pieceCount(fileSize: Int64, chunkSize: Int) -> Int? {
        guard fileSize > 0, (1...maximumPieceSize).contains(chunkSize) else { return nil }
        let count = (fileSize - 1) / Int64(chunkSize) + 1
        return count <= maximumPieces ? Int(count) : nil
    }

    private static func hashBytes(_ fileHash: String) -> Data? {
        guard fileHash.utf8.count == digestSize * 2 else { return nil }
        let bytes = Array(fileHash.utf8)
        var digest = Data(capacity: digestSize)
        for index in stride(from: 0, to: bytes.count, by: 2) {
            guard let high = hexValue(bytes[index]), let low = hexValue(bytes[index + 1]) else { return nil }
            digest.append(high * 16 + low)
        }
        return digest
    }

    private static func hexValue(_ byte: UInt8) -> UInt8? {
        switch byte {
        case 48...57: byte - 48
        case 65...70: byte - 55
        case 97...102: byte - 87
        default: nil
        }
    }
}
