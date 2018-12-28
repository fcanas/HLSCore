//
//  MediaPlaylistParser.swift
//  HLSCore
//
//  Created by Fabian Canas on 10/16/16.
//  Copyright © 2016 Fabian Canas. All rights reserved.
//

import Foundation
import Types
import FFCParserCombinator
import FFCLog

let newlines = BasicParser.newline.many1

public func parseMediaPlaylist(string :String, atURL url: URL) -> MediaPlaylist? {
    let parser = PlaylistStart *> newlines *> ( MediaPlaylistTag <* newlines ).many
    
    let parseResult = parser.run(string)

    struct OpenMediaSegment {
        var duration :TimeInterval?
        var title :String?
        var byteRange :CountableClosedRange<UInt>?
        var programDateTime :Date?
        var discontinuity :Bool?
        var mediaInitializationSection: MediaInitializationSection?
    }
    
    struct PlaylistBuilder {
        var playlistType :MediaPlaylist.PlaylistType?
        var version :UInt = 1
        var duration :TimeInterval?
        var start :StartIndicator?
        var segments :[MediaSegment] = []
        var closed :Bool = false
        
        var activeKey :DecryptionKey?
        var activeMediaInitializationSection :MediaInitializationSection?
        
        var openSegment :OpenMediaSegment?
        
        var fatalTag :AnyTag?
    }
    
    if let remainingChars = parseResult?.1 , (remainingChars.count > 0) {
        log("REMAINDER:\n\(String(remainingChars))", level: .error)
    } else {
        log("NO REMAINDER", level: .info)
    }
    
    guard let tags = parseResult?.0 else {
        return nil
    }
    
    let playlistBuilder = tags.reduce(PlaylistBuilder(), { (state :PlaylistBuilder, tag :AnyTag) -> PlaylistBuilder in
        
        var builder = state
        
        switch tag {
        case let .playlist(playlist):
            switch playlist {
            case let .version(version):
                builder.version = version
            case .independentSegments:
                // TODO: encode independent segments in structs
                break
            case let .startIndicator(start):
                builder.start = start
            case let .url(segmentURL):
                let openSegment = builder.openSegment
                guard let duration = openSegment?.duration else {
                    builder.fatalTag = tag
                    break
                }
                let fullSegmentURL = URL(string:segmentURL.absoluteString, relativeTo: url)!
                
                builder.segments.append(MediaSegment(uri: fullSegmentURL, duration: duration, title: openSegment?.title, byteRange: openSegment?.byteRange, decryptionKey: builder.activeKey, date: openSegment?.programDateTime, mediaInitializationSection: builder.activeMediaInitializationSection))
                builder.openSegment = nil
            case .comment(_):
                break
            }
        case let .media(media):
            switch media {
            case let .targetDuration(duration):
                switch duration {
                case let .decimalFloatingPoint(f):
                    builder.duration = f
                case let .decimalInteger(i):
                    builder.duration = TimeInterval(i)
                default:
                    builder.fatalTag = tag
                }
            case .mediaSequence(_):
                // TODO: Media Sequence Unimplemented
                break
            case .discontinuitySequence(_):
                // TODO: Discontinuity Sequence Unimplemented
                break
            case .endList:
                builder.closed = true
            case let .playlistType(type):
                switch type {
                case let .enumeratedString(string):
                    builder.playlistType = MediaPlaylist.PlaylistType(rawValue: string.rawValue)
                default:
                    builder.fatalTag = tag
                }
            case .iFramesOnly:
                // TODO: i-frame lists not implemented
                break
            }
        case let .segment(segment):
            var openSegment = builder.openSegment ?? OpenMediaSegment()
            
            switch segment {
            case let .inf(duration, title):
                switch duration {
                case let .decimalFloatingPoint(f):
                    openSegment.duration = f
                case let .decimalInteger(i):
                    openSegment.duration = TimeInterval(i)
                default:
                    builder.fatalTag = tag
                }
                openSegment.title = title
            case let .byteRange(byteRange):
                openSegment.byteRange = byteRange
            case .discontinuity:
                // Probably applies to the _next_ segment, not the current one.
                openSegment.discontinuity = true
            case let .key(key):
                builder.activeKey = key
            case let .map(mediaInitialization):
                builder.activeMediaInitializationSection = mediaInitialization
            case let .programDateTime(date):
                openSegment.programDateTime = date
            case .dateRange(_):
                // TODO: Date Range
                break
            }
            openSegment.mediaInitializationSection = builder.activeMediaInitializationSection
            builder.openSegment = openSegment
            
        case .master(_):
            builder.fatalTag = tag
        }
        
        return builder
    })
    
    guard playlistBuilder.fatalTag == nil else {
        log("Fatal tag encountered in media playlist: \(playlistBuilder.fatalTag!)", level: .fatal)
        return nil
    }
    
    guard let targetDuration = playlistBuilder.duration else {
        return nil
    }
    
    return MediaPlaylist(type: playlistBuilder.playlistType, version: playlistBuilder.version, uri: url, targetDuration: targetDuration, closed: playlistBuilder.closed, start: playlistBuilder.start, segments: playlistBuilder.segments)
}
