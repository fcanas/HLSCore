//
//  Playlist.swift
//  HLSCore
//
//  Created by Fabian Canas on 9/2/16.
//  Copyright © 2016 Fabian Canas. All rights reserved.
//

import Foundation
import Utilities

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

/// Media Playlist

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
