import Foundation
import CZlib

public enum CompressionMethod: Sendable { case none, gzip, deflate }

extension CompressionMethod {
    public func compress(_ data: Data) throws -> Data {
        guard self != .none else { return data }
        var stream = z_stream()
        let window = self == .gzip ? MAX_WBITS + 16 : -MAX_WBITS
        guard deflateInit2_(&stream, Z_DEFAULT_COMPRESSION, Z_DEFLATED, window, 8,
                            Z_DEFAULT_STRATEGY, ZLIB_VERSION, Int32(MemoryLayout<z_stream>.size)) == Z_OK else {
            throw BaseApiError(code: 108, title: "Compression initialization failed")
        }
        defer { deflateEnd(&stream) }
        return try data.withUnsafeBytes { input in
            stream.next_in = UnsafeMutablePointer(mutating: input.bindMemory(to: Bytef.self).baseAddress)
            stream.avail_in = uInt(input.count)
            var result = Data()
            var status: Int32 = Z_OK
            repeat {
                var buffer = [UInt8](repeating: 0, count: 16_384)
                let count = buffer.count
                status = buffer.withUnsafeMutableBytes { output in
                    stream.next_out = output.bindMemory(to: Bytef.self).baseAddress
                    stream.avail_out = uInt(count)
                    return CZlib.deflate(&stream, Z_FINISH)
                }
                guard status == Z_OK || status == Z_STREAM_END else {
                    throw BaseApiError(code: 108, title: "Compression failed")
                }
                result.append(contentsOf: buffer.prefix(count - Int(stream.avail_out)))
            } while status != Z_STREAM_END
            return result
        }
    }
}
