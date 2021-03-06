//
//  Playlist.swift
//  HLSCore
//
//  Created by Fabian Canas on 9/2/16.
//  Copyright © 2016 Fabian Canas. All rights reserved.
//

import Foundation

public protocol Playlist {
    var version: UInt { get }
    var start: StartIndicator? { get }
}

/// Master Playlist

public struct MasterPlaylist: Playlist {
    public let version: UInt
    public let uri: URL

    public let renditions: [Rendition]
    public let streams: [StreamInfo]
    public let start: StartIndicator?

    public init(version: UInt, uri: URL, streams: [StreamInfo], renditions: [Rendition], start: StartIndicator?) {
        self.version = version
        self.uri = uri
        self.streams = streams
        self.renditions = renditions
        self.start = start
    }
}

/// Media Playlist

public struct MediaPlaylist: Playlist, Equatable {

    public enum PlaylistType: String {
        case VOD = "VOD"
        case Event = "EVENT"
    }

    public init(type: PlaylistType?,
                version: UInt = 1,
                uri: URL,
                targetDuration: TimeInterval,
                closed: Bool,
                start: StartIndicator? = nil,
                segments: [MediaSegment],
                independentSegments: Bool,
                mediaSequence: UInt) {
        self.type = type
        self.version = version
        self.uri = uri
        self.targetDuration = targetDuration
        self.closed = closed
        self.start = start
        self.segments = segments.map({ (segment) -> MediaSegment in
            MediaSegment(uri: segment.resource.uri.relativeURL(baseURL: uri.directoryURL()),
                         duration: segment.duration,
                         title: segment.title,
                         byteRange: segment.byteRange,
                         decryptionKey: segment.decryptionKey,
                         mediaInitializationSection: segment.mediaInitializationSection)
        })
        self.independentSegments = independentSegments
        self.mediaSequence = mediaSequence
    }

    public let type: PlaylistType?

    public let version: UInt
    // private var playlist :MasterPlaylist? = nil

    public let uri: URL

    public let targetDuration: TimeInterval

    /// Marks the presence of a `EXT-X-ENDLIST` tag
    public let closed: Bool

    public let start: StartIndicator?

    // TODO : a playlist should probably _be_ a sequence of media segments
    public let segments: [MediaSegment]

    public let independentSegments: Bool

    /// Media Sequence of the first segment
    public let mediaSequence: UInt
}
