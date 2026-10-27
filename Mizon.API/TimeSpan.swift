import Foundation

/// .NET constant-format TimeSpan: [-][d.]hh:mm:ss[.fffffff].
public struct TimeSpan: Codable, Sendable, Equatable, Hashable {
    public var ticks: Int64
    public var totalSeconds: Double { Double(ticks) / 10_000_000 }
    public var totalMilliseconds: Double { Double(ticks) / 10_000 }
    public init(ticks: Int64 = 0) { self.ticks = ticks }
    public init(seconds: Double) { self.ticks = Int64(seconds * 10_000_000) }
    public init(from decoder: any Decoder) throws {
        let c = try decoder.singleValueContainer()
        let text = try c.decode(String.self)
        let pattern = /^(-)?(?:(\d+)\.)?(\d{2}):(\d{2}):(\d{2})(?:\.(\d{1,7}))?$/
        guard let m = text.wholeMatch(of: pattern), let hours = Int64(m.3), hours < 24,
              let minutes = Int64(m.4), minutes < 60, let seconds = Int64(m.5), seconds < 60 else {
            throw DecodingError.dataCorruptedError(in: c, debugDescription: "Invalid .NET TimeSpan")
        }
        guard let days = UInt64(m.2 ?? "0") else {
            throw DecodingError.dataCorruptedError(in: c, debugDescription: "TimeSpan overflow")
        }
        let fraction = String(m.6 ?? "")
        let fractionalTicks = UInt64(fraction.padding(toLength: 7, withPad: "0", startingAt: 0)) ?? 0
        let dayTicks = days.multipliedReportingOverflow(by: 864_000_000_000)
        let timeTicks = UInt64(hours * 3_600 + minutes * 60 + seconds) * 10_000_000 + fractionalTicks
        let total = dayTicks.partialValue.addingReportingOverflow(timeTicks)
        let negative = m.1 != nil
        let limit = UInt64(Int64.max) + (negative ? 1 : 0)
        guard !dayTicks.overflow, !total.overflow, total.partialValue <= limit else {
            throw DecodingError.dataCorruptedError(in: c, debugDescription: "TimeSpan overflow")
        }
        ticks = total.partialValue == UInt64(Int64.max) + 1 ? Int64.min : (negative ? -Int64(total.partialValue) : Int64(total.partialValue))

    }
    public func encode(to encoder: any Encoder) throws {
        var c = encoder.singleValueContainer()
        let value = ticks.magnitude
        let seconds = value / 10_000_000
        let days = seconds / 86_400
        let fraction = value % 10_000_000
        let time = String(format: "%02llu:%02llu:%02llu", seconds / 3_600 % 24, seconds / 60 % 60, seconds % 60)
        try c.encode((ticks < 0 ? "-" : "") + (days > 0 ? "\(days)." : "") + time + (fraction > 0 ? String(format: ".%07llu", fraction) : ""))
    }
}
