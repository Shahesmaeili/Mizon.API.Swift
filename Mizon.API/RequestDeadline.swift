import Foundation

/// URLRequest.timeoutInterval is an inactivity timeout; .NET's cancellation
/// source limits the entire call, including streaming response bodies.
func withRequestDeadline<Value: Sendable>(seconds: TimeInterval,
    operation: @escaping @Sendable () async throws -> Value) async throws -> Value {
    guard seconds.isFinite, seconds > 0 else { throw BaseApiError(code: 108, title: "Invalid timeout") }
    return try await withThrowingTaskGroup(of: Value.self) { group in
        group.addTask { try await operation() }
        group.addTask {
            try await Task.sleep(for: .seconds(seconds))
            throw BaseApiError(code: 106, title: "Request Timeout")
        }
        defer { group.cancelAll() }
        return try await group.next()!
    }
}
