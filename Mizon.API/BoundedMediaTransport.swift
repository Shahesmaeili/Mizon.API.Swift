import Foundation

package enum BoundedMediaTransport {
    package static func readBody(_ bytes: URLSession.AsyncBytes, response: HTTPURLResponse, limit: Int, exact: Bool = false) async throws -> Data {
        let advertisedSize = response.expectedContentLength
        guard advertisedSize < 0 || (advertisedSize <= Int64(limit) && (!exact || advertisedSize == Int64(limit))) else {
            throw BaseApiError(code: 102, title: "Invalid media response length")
        }
        var data = Data(capacity: advertisedSize >= 0 ? Int(advertisedSize) : min(limit, 64 * 1024))
        for try await byte in bytes {
            guard data.count < limit else { throw BaseApiError(code: 102, title: "Oversized media response") }
            data.append(byte)
        }
        if exact && data.count != limit { throw BaseApiError(code: 102, title: "Truncated media response") }
        return data
    }

    package static func readRange(_ range: ClosedRange<Int64>, fileSize: Int64, request: URLRequest, session: URLSession) async throws -> Data {
        var rangeRequest = request
        rangeRequest.httpMethod = "GET"
        rangeRequest.setValue("*/*", forHTTPHeaderField: "Accept")
        rangeRequest.setValue("identity", forHTTPHeaderField: "Accept-Encoding")
        rangeRequest.setValue("bytes=\(range.lowerBound)-\(range.upperBound)", forHTTPHeaderField: "Range")
        let transportRequest = rangeRequest
        let count = Int(range.upperBound - range.lowerBound + 1)
        return try await withRequestDeadline(seconds: transportRequest.timeoutInterval) {
            let (bytes, response) = try await session.bytes(for: transportRequest, delegate: MediaNoRedirect())
            do {
                guard let response = response as? HTTPURLResponse else {
                    throw BaseApiError(code: 107, title: "Invalid media response")
                }
                if response.statusCode == 206 {
                    let expectedRange = "bytes \(range.lowerBound)-\(range.upperBound)/\(fileSize)"
                    guard response.value(forHTTPHeaderField: "Content-Range") == expectedRange else {
                        throw BaseApiError(code: 102, title: "Invalid media Content-Range")
                    }
                } else if !(response.statusCode == 200 && range.lowerBound == 0 && range.upperBound == fileSize - 1) {
                    throw BaseApiError(code: response.statusCode, title: "Media server did not honor byte range")
                }
                return try await readBody(bytes, response: response, limit: count, exact: true)
            } catch {
                bytes.task.cancel()
                throw error
            }
        }
    }
}

final class MediaNoRedirect: NSObject, URLSessionTaskDelegate, Sendable {
    func urlSession(_ session: URLSession, task: URLSessionTask, willPerformHTTPRedirection response: HTTPURLResponse,
                    newRequest request: URLRequest, completionHandler: @escaping @Sendable (URLRequest?) -> Void) {
        completionHandler(nil)
    }
}
