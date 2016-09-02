//
//  HLSCore.swift
//  HLSCore
//
//  Created by Fabian Canas on 8/13/16.
//  Copyright © 2016 Fabian Canas. All rights reserved.
//

import Foundation

/// EXT-X-START
public struct StartIndicator {
    let timeOffset :TimeInterval
    let preciseStart :Bool = false
}

protocol Playlist {
    var version :Int { get }
    var start :StartIndicator? { get }
}

/// Master Playlist

public struct MasterPlaylist : Playlist {
    public let version: Int
    public let uri :URL
    
    public let streams :[MediaPlaylist]
    public let start :StartIndicator?
}

enum MediaType {
    case Audio
    case Video
    case Subtitles
    case ClosedCaptions
}

/// EXT-X-MEDIA
struct Rendition {
    let language :Language
    let name :String
    
    init(language: Language, name: String, defaultRendition: Bool = false, forced: Bool = false) {
        self.language = language
        self.name = name
        self.defaultRendition = defaultRendition
        self.forced = forced
    }
    
    fileprivate let defaultRendition :Bool
    fileprivate let forced :Bool
}

extension Rendition : Equatable {
    static func ==(lhs: Rendition, rhs: Rendition) -> Bool {
        return lhs.language == rhs.language &&
               lhs.name == rhs.name
    }
}

struct RenditionGroup {
    let groupId :String
    let type :MediaType
    
    let renditions :[Rendition]
    
    init(groupId: String, type: MediaType, renditions: [Rendition]) {
        self.groupId = groupId
        self.type = type
        self.renditions = renditions
        
        defaultRendition = renditions.first(where: { $0.defaultRendition })
        forcedRenditions = renditions.filter { $0.forced }
    }
    
    let defaultRendition :Rendition?
    
    let forcedRenditions :[Rendition]
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

struct Resolution {
    let width :Int
    let height :Int
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

public struct MediaPlaylist : Playlist {
    
    public enum PlaylistType : CustomStringConvertible {
        case VOD
        case Event
        
        public var description :String {
            switch self {
            case .VOD:
                return "VOD"
            case .Event:
                return "EVENT"
            }
        }
    }
    
    public init(type: PlaylistType?, version: Int = 1, uri: URL, targetDuration: TimeInterval, closed: Bool, start: StartIndicator? = nil, segments: [MediaSegment]) {
        self.type = type
        self.version = version
        self.uri = uri
        self.targetDuration = targetDuration
        self.closed = closed
        self.start = start
        self.segments = segments.map({ (segment) -> MediaSegment in
            MediaSegment(uri: segment.resource.uri.relativeURL(baseURL: uri.directoryURL()), duration: segment.duration, title: segment.title, byteRange: segment.byteRange)
        })
    }
    
    public let type :PlaylistType?
    
    public let version :Int
    // private var playlist :MasterPlaylist? = nil
    
    public let uri :URL
    
    public let targetDuration :TimeInterval
    
    /// Marks the presence of a `EXT-X-ENDLIST` tag
    public let closed :Bool
    
    public let start :StartIndicator?
    
    // TODO : a playlist should probably _be_ a sequence of media segments
    public let segments :[MediaSegment]
}

/// Media

public struct MediaSegment {
    private var playlist :MediaPlaylist?
    
    public var resource :MediaResource
    
    public init(uri: URL, duration: TimeInterval, title :String? = nil, byteRange: ByteRange? = nil) {
        resource = MediaResource(uri: uri)
        self.duration = duration
        self.title = title
        self.byteRange = byteRange
    }
    
    // EXTINF
    
    public let duration :TimeInterval
    let title :String?
    
    // EXT-X-BYTERANGE
    
    let byteRange :ByteRange?
    
}

public struct ByteRange {
    
    // TODO : Make this a real range type.
    //        Or a protocol that can be massaged into various different range uses
    
    let length :UIntMax
    let offset :UIntMax
}

public struct MediaResource {
    public let uri :URL
}
