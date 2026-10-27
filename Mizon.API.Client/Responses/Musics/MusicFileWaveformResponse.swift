import Foundation
import MizonAPI

public struct MusicFileWaveformResponse: IApiResponse {
    public var waveforms: [WaveformResponse]
    public var lightingProfile: MusicLightingProfileResponse

    public init(waveforms: [WaveformResponse] = [], lightingProfile: MusicLightingProfileResponse = MusicLightingProfileResponse()) {
        self.waveforms = waveforms
        self.lightingProfile = lightingProfile
    }

    enum CodingKeys: String, CodingKey {
        case waveforms
        case lightingProfile
    }

    public init(from decoder: any Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        waveforms = try values.decodeIfPresent([WaveformResponse].self, forKey: .waveforms) ?? []
        lightingProfile = try values.decodeIfPresent(MusicLightingProfileResponse.self, forKey: .lightingProfile) ?? MusicLightingProfileResponse()
    }
    public func encode(to encoder: any Encoder) throws {
        var c = encoder.container(keyedBy: CodingKeys.self)
        try c.encode(waveforms, forKey: .waveforms)
        try c.encode(lightingProfile, forKey: .lightingProfile)
    }

}

public struct MusicLightingProfileResponse: Codable, Sendable {
    public var primaryColor: String

    public init(primaryColor: String = "#00B4FF") {
        self.primaryColor = primaryColor
    }

    enum CodingKeys: String, CodingKey {
        case primaryColor
    }

    public init(from decoder: any Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        primaryColor = try values.decodeIfPresent(String.self, forKey: .primaryColor) ?? "#00B4FF"
    }
    public func encode(to encoder: any Encoder) throws {
        var c = encoder.container(keyedBy: CodingKeys.self)
        try c.encode(primaryColor, forKey: .primaryColor)
    }

}

public struct WaveformResponse: Codable, Sendable {
    public var offsetInMilliseconds: Int
    public var minimumAmplitude: Int16
    public var maximumAmplitude: Int16
    public var rms: Float
    public var peak: Int16
    public var transient: Float
    public var isClipping: Bool

    public init(offsetInMilliseconds: Int = 0, minimumAmplitude: Int16 = 0, maximumAmplitude: Int16 = 0, rms: Float = 0, peak: Int16 = 0, transient: Float = 0, isClipping: Bool = false) {
        self.offsetInMilliseconds = offsetInMilliseconds
        self.minimumAmplitude = minimumAmplitude
        self.maximumAmplitude = maximumAmplitude
        self.rms = rms
        self.peak = peak
        self.transient = transient
        self.isClipping = isClipping
    }

    enum CodingKeys: String, CodingKey {
        case offsetInMilliseconds
        case minimumAmplitude
        case maximumAmplitude
        case rms
        case peak
        case transient
        case isClipping
    }

    public init(from decoder: any Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        offsetInMilliseconds = try values.decodeIfPresent(Int.self, forKey: .offsetInMilliseconds) ?? 0
        minimumAmplitude = try values.decodeIfPresent(Int16.self, forKey: .minimumAmplitude) ?? 0
        maximumAmplitude = try values.decodeIfPresent(Int16.self, forKey: .maximumAmplitude) ?? 0
        rms = try values.decodeIfPresent(Float.self, forKey: .rms) ?? 0
        peak = try values.decodeIfPresent(Int16.self, forKey: .peak) ?? 0
        transient = try values.decodeIfPresent(Float.self, forKey: .transient) ?? 0
        isClipping = try values.decodeIfPresent(Bool.self, forKey: .isClipping) ?? false
    }
    public func encode(to encoder: any Encoder) throws {
        var c = encoder.container(keyedBy: CodingKeys.self)
        try c.encode(offsetInMilliseconds, forKey: .offsetInMilliseconds)
        try c.encode(minimumAmplitude, forKey: .minimumAmplitude)
        try c.encode(maximumAmplitude, forKey: .maximumAmplitude)
        try c.encode(rms, forKey: .rms)
        try c.encode(peak, forKey: .peak)
        try c.encode(transient, forKey: .transient)
        try c.encode(isClipping, forKey: .isClipping)
    }

}

