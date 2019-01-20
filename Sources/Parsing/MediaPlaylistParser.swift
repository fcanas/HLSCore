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

private struct OpenMediaSegment {
    var duration: TimeInterval?
    var title: String?
    var byteRange: CountableClosedRange<UInt>?
    var programDateTime: Date?
    var discontinuity: Bool?
    var mediaInitializationSection: MediaInitializationSection?
}

private struct PlaylistBuilder {
    var url: URL
    var playlistType: MediaPlaylist.PlaylistType?
    var version: UInt = 1
    var duration: TimeInterval?
    var start: StartIndicator?
    var segments: [MediaSegment] = []
    var closed: Bool = false
    var independentSegments: Bool = false
    var mediaSequence: UInt = 0

    var activeKey: DecryptionKey?
    var activeMediaInitializationSection: MediaInitializationSection?

    var openSegment: OpenMediaSegment?

    var fatalTag: AnyTag?

    init(rootURL: URL) {
        url = rootURL
    }
}

public func parseMediaPlaylist(string: String, atURL url: URL) -> MediaPlaylist? {
    let parser = PlaylistStart *> newlines *> ( MediaPlaylistTag <* newlines ).many

    let parseResult = parser.run(string)

    if let remainingChars = parseResult?.1, (remainingChars.count > 0) {
        log("REMAINDER:\n\(String(remainingChars))", level: .error)
    } else {
        log("NO REMAINDER", level: .info)
    }

    guard let tags = parseResult?.0 else {
        return nil
    }

    let playlistBuilder = tags.reduce(PlaylistBuilder(rootURL: url), reduceTag)

    guard playlistBuilder.fatalTag == nil else {
        log("Fatal tag encountered in media playlist: \(playlistBuilder.fatalTag!)", level: .fatal)
        return nil
    }

    guard let targetDuration = playlistBuilder.duration else {
        return nil
    }

    return MediaPlaylist(type: playlistBuilder.playlistType,
                         version: playlistBuilder.version,
                         uri: playlistBuilder.url,
                         targetDuration: targetDuration,
                         closed: playlistBuilder.closed,
                         start: playlistBuilder.start,
                         segments: playlistBuilder.segments,
                         independentSegments: playlistBuilder.independentSegments,
                         mediaSequence: playlistBuilder.mediaSequence)
}

// swiftlint:disable function_body_length cyclomatic_complexity
private func reduceTag(state: PlaylistBuilder, tag: AnyTag) -> PlaylistBuilder {

    var builder = state

    switch tag {
    case let .playlist(playlist):
        switch playlist {
        case let .version(version):
            builder.version = version
        case .independentSegments:
            builder.independentSegments = true
        case let .startIndicator(start):
            builder.start = start
        case let .url(segmentURL):
            let openSegment = builder.openSegment
            guard let duration = openSegment?.duration else {
                builder.fatalTag = tag
                break
            }
            let fullSegmentURL = URL(string: segmentURL.absoluteString, relativeTo: state.url)!
            let segment = MediaSegment(uri: fullSegmentURL,
                                       duration: duration,
                                       title: openSegment?.title,
                                       byteRange: openSegment?.byteRange,
                                       decryptionKey: builder.activeKey,
                                       date: openSegment?.programDateTime,
                                       mediaInitializationSection: builder.activeMediaInitializationSection)
            builder.segments.append(segment)
            builder.openSegment = nil
        case .comment(_):
            break
        }
    case let .media(media):
        switch media {
        case let .targetDuration(duration):
            switch duration {
            case let .decimalFloatingPoint(float):
                builder.duration = float
            case let .decimalInteger(int):
                builder.duration = TimeInterval(int)
            default:
                builder.fatalTag = tag
            }
        case let .mediaSequence(sequence):
            switch sequence {
            case let .decimalInteger(sequence):
                builder.mediaSequence = sequence
            default:
                builder.fatalTag = tag
            }
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
            case let .decimalFloatingPoint(float):
                openSegment.duration = float
            case let .decimalInteger(int):
                openSegment.duration = TimeInterval(int)
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
            let mediaInitializationURI = URL(string: mediaInitialization.uri.absoluteString, relativeTo: state.url)!
            let mediaInitializationSection = MediaInitializationSection(uri: mediaInitializationURI,
                                                                        byteRange: mediaInitialization.byteRange)
            builder.activeMediaInitializationSection = mediaInitializationSection
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
}
// swiftlint:enable function_body_length cyclomatic_complexity}
