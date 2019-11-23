//
//  MasterPlaylistParser.swift
//  HLSCore
//
//  Created by Fabian Canas on 10/22/16.
//  Copyright © 2016 Fabian Canas. All rights reserved.
//

import Foundation
import Types
import FFCParserCombinator

private struct PlaylistBuilder {
    var version: UInt = 1
    var streams: [StreamInfo] = []
    var start: StartIndicator?
    var independentSegments: Bool = false
    var renditions: [Rendition] = []
    let url: URL

    var fatalTag: AnyTag?
    init(rootURL: URL) {
        url = rootURL
        start = nil
    }
}

public func parseMasterPlaylist(string: String, atURL url: URL, logger: Logger = HLSLogging.Default()) -> MasterPlaylist? {
    let parser = HLS.Playlist.StartTag *> newlines *> ( HLS.Playlist.Master.TagParser <* newlines ).many

    let parseResult = parser.run(string)

    if let remainingChars = parseResult?.1, (remainingChars.count > 0) {
        logger.log("REMAINDER:\n\(String(remainingChars))", level: .error)
    } else {
        logger.log("NO REMAINDER", level: .info)
    }

    guard let tags = parseResult?.0 else {
        return nil
    }

    let reducer = { (state: PlaylistBuilder, tag: AnyTag) in
        reducePlaylistBuilder(state: state, tag: tag, logger: logger)
    }

    let playlistBuilder = tags.reduce(PlaylistBuilder(rootURL: url), reducer)

    let streams = playlistBuilder.streams.map {
        StreamInfo(bandwidth: $0.bandwidth,
                   averageBandwidth: $0.averageBandwidth,
                   codecs: $0.codecs,
                   resolution: $0.resolution,
                   frameRate: $0.frameRate,
                   uri: URL(string: $0.uri.absoluteString, relativeTo: url )!)
    }

    let renditions = playlistBuilder.renditions.map {
        Rendition(mediaType: $0.type,
                  uri: $0.uri.flatMap({URL(string: $0.absoluteString, relativeTo: url)}),
                  groupID: $0.groupID,
                  language: $0.language,
                  associatedLanguage: $0.associatedLanguage,
                  name: $0.name,
                  defaultRendition: $0.defaultRendition,
                  forced: $0.forced)
    }

    return MasterPlaylist(version: playlistBuilder.version,
                          uri: url, streams: streams,
                          renditions: renditions,
                          start: playlistBuilder.start)
}

private func reducePlaylistBuilder(state: PlaylistBuilder, tag: AnyTag, logger: Logger) -> PlaylistBuilder {
    var returnState = state

    switch tag {
    case let .playlist(playlistTag):
        switch playlistTag {
        case let .version(versionNumber):
            returnState.version = versionNumber
        case .independentSegments:
            returnState.independentSegments = true
        case let .startIndicator(start):
            returnState.start = start
        case .url(_):
            // Playlist URLs are handled by the #EXT-X-STREAM-INF tag since
            // they're required to be sequential
            // TODO: Move URL tag into the media or segment type?
            returnState.fatalTag = tag
        case .comment(_):
            break
        }
    case .media(_):
        returnState.fatalTag = tag
    case .segment(_):
        returnState.fatalTag = tag
    case let .master(masterTag):
        switch masterTag {
        case let .media(rendition):
            returnState.renditions.append(rendition)
        case let .streamInfo(streamInfo):
            returnState.streams.append(streamInfo)
        case let .iFramesStreamInfo(attributes):
            // TODO: iFrame Stream Info
            logger.log("Unprocessed iFrame Stream Info :: \(attributes)", level: .error)
        case let .sessionData(attributes):
            // TODO: Session Data
            logger.log("Unprocessed Session Data :: \(attributes)", level: .error)
        case let .sessionKey(attributes):
            // TODO: Session Key
            logger.log("Unprocessed Session Key :: \(attributes)", level: .error)
        }
    }

    return returnState
}
