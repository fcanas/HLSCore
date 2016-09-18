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
struct Bitrate : Comparable {
    let value :UInt
    
    static func ==(lhs: Bitrate, rhs: Bitrate) -> Bool {
        return lhs.value == rhs.value
    }
    
    static func <(lhs: Bitrate, rhs: Bitrate) -> Bool {
        return lhs.value < rhs.value
    }
    
    func toUIntMax() -> UIntMax {
        return value.toUIntMax()
    }
    
    init(_ v: UIntMax) {
        value = UInt(v)
    }
}

/// RFC6381
struct Codec {
    // TODO
}

/// EXT-X-STREAM-INF
struct StreamInfo {
    /// Peak segment bitrate in bits per second
    let bandwidth :Bitrate
    let averageBandwidth :Bitrate
    let codecs :[Codec]
    let resolution :Resolution
    let frameRate :Double
    
    let uri :URL
}

/// Media

public struct MediaSegment {
    private var playlist :MediaPlaylist?
    
    public var resource :MediaResource
    
    public init(uri: URL, duration: TimeInterval, title :String? = nil, byteRange: Range<UInt>? = nil) {
        resource = MediaResource(uri: uri)
        self.duration = duration
        self.title = title
        self.byteRange = byteRange
    }
    
    // EXTINF
    
    public let duration :TimeInterval
    let title :String?
    
    // EXT-X-BYTERANGE
    
    let byteRange :Range<UInt>?
    
}

public struct MediaResource {
    public let uri :URL
}
