//
//  HLSCore.swift
//  HLSCore
//
//  Created by Fabian Canas on 8/13/16.
//  Copyright © 2016 Fabian Canas. All rights reserved.
//

import Foundation
import Utilities

/// EXT-X-START
public struct StartIndicator {
    let timeOffset :TimeInterval
    let preciseStart :Bool
    public init(at timeOffset: TimeInterval, preciseStart: Bool = false) {
        self.timeOffset = timeOffset
        self.preciseStart = preciseStart
    }
}

extension StartIndicator : Equatable {
    public static func ==(lhs: StartIndicator, rhs: StartIndicator) -> Bool {
        return lhs.timeOffset == rhs.timeOffset && lhs.preciseStart == rhs.preciseStart
    }
}

public enum MediaType {
    case Audio
    case Video
    case Subtitles
    case ClosedCaptions
}

/// EXT-X-MEDIA
public struct Rendition {
    let language :Language
    let name :String
    
    public init(language: Language, name: String, defaultRendition: Bool = false, forced: Bool = false) {
        self.language = language
        self.name = name
        self.defaultRendition = defaultRendition
        self.forced = forced
    }
    
    fileprivate let defaultRendition :Bool
    fileprivate let forced :Bool
}

extension Rendition : Equatable {
    public static func ==(lhs: Rendition, rhs: Rendition) -> Bool {
        return lhs.language == rhs.language &&
               lhs.name == rhs.name
    }
}

public struct RenditionGroup {
    let groupId :String
    let type :MediaType
    
    let renditions :[Rendition]
    
    public init(groupId: String, type: MediaType, renditions: [Rendition]) {
        self.groupId = groupId
        self.type = type
        self.renditions = renditions
        
        defaultRendition = renditions.first(where: { $0.defaultRendition })
        forcedRenditions = renditions.filter { $0.forced }
    }
    
    public let defaultRendition :Rendition?
    
    public let forcedRenditions :[Rendition]
}

/// Bits per second
public struct Bitrate : Comparable {
    public let value :UInt
    
    public static func ==(lhs: Bitrate, rhs: Bitrate) -> Bool {
        return lhs.value == rhs.value
    }
    
    public static func <(lhs: Bitrate, rhs: Bitrate) -> Bool {
        return lhs.value < rhs.value
    }
    
    public func toUIntMax() -> UIntMax {
        return value.toUIntMax()
    }
    
    public init(_ v: UIntMax) {
        value = UInt(v)
    }
}

/** 
 MIME type/subtypes representing different media formats.
 
 TODO: Implementation of RFC6381 would be useful. Right now, a `Codec` is a dumb
 `String`.
 https://tools.ietf.org/html/rfc6381
 */
public struct Codec : RawRepresentable, Equatable, Hashable, Comparable {
    //
    public let rawValue :String
    
    public init(rawValue: String) {
        self.rawValue = rawValue
    }
    
    public var hashValue: Int {
        return rawValue.hashValue
    }
    
    public static func ==(lhs: Codec, rhs: Codec) -> Bool {
        return lhs.rawValue == rhs.rawValue
    }
    
    public static func <(lhs: Codec, rhs: Codec) -> Bool {
        return lhs.rawValue < rhs.rawValue
    }
}

/// EXT-X-STREAM-INF
public struct StreamInfo {
    /// Peak segment bitrate in bits per second
    public let bandwidth :Bitrate
    public let averageBandwidth :Bitrate?
    public let codecs :[Codec]
    public let resolution :Resolution?
    public let frameRate :Double?
    
    public let uri :URL
    
    public init(bandwidth: Bitrate, averageBandwidth: Bitrate?, codecs :[Codec], resolution: Resolution?, frameRate: Double?, uri: URL) {
        self.bandwidth = bandwidth
        self.averageBandwidth = averageBandwidth
        self.codecs = codecs
        self.resolution = resolution
        self.frameRate = frameRate
        self.uri = uri
    }
}

/// Media

public struct MediaSegment {
    private var playlist :MediaPlaylist?
    
    public var resource :MediaResource
    
    public init(uri: URL, duration: TimeInterval, title :String? = nil, byteRange: CountableClosedRange<UInt>? = nil, decryptionKey: DecryptionKey? = nil, date: Date? = nil, mediaInitializationSection: MediaInitializationSection? = nil) {
        resource = MediaResource(uri: uri)
        self.duration = duration
        self.title = title
        self.byteRange = byteRange
        self.decryptionKey = decryptionKey
        self.programDateTime = date
        self.mediaInitializationSection = mediaInitializationSection
    }
    
    // EXTINF
    
    public let duration :TimeInterval
    let title :String?
    
    // EXT-X-BYTERANGE
    
    let byteRange :CountableClosedRange<UInt>?
    
    public var decryptionKey :DecryptionKey?
    
    public var programDateTime :Date?
    
    public var mediaInitializationSection :MediaInitializationSection?
    
}

extension MediaSegment : Equatable {
    public static func ==(lhs: MediaSegment, rhs: MediaSegment) -> Bool {
        return lhs.resource == rhs.resource
            && lhs.title == rhs.title
            && lhs.byteRange == rhs.byteRange
            && lhs.duration == rhs.duration
    }
}

public struct MediaInitializationSection {
    public let uri: URL
    public let byteRange :CountableClosedRange<UInt>?
    
    public init(uri: URL, byteRange :CountableClosedRange<UInt>?) {
        self.uri = uri
        self.byteRange = byteRange
    }
}

public struct MediaResource {
    public let uri :URL
}

extension MediaResource : Equatable {
    public static func ==(lhs: MediaResource, rhs: MediaResource) -> Bool {
        return lhs.uri == rhs.uri
    }
}
