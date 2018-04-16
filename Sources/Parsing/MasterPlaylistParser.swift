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
import FFCLog

public func parseMasterPlaylist(string: String, atURL url: URL) -> MasterPlaylist? {
    let parser = PlaylistStart *> newlines *> ( MasterPlaylistTag <* newlines ).many
    
    let parseResult = parser.run(string)
    
    if let remainingChars = parseResult?.1 , (remainingChars.count > 0) {
        log("REMAINDER:\n\(String(remainingChars))", level: .error)
    } else {
        log("NO REMAINDER", level: .info)
    }
    
    guard let tags = parseResult?.0 else {
        return nil
    }
    
    struct PlaylistBuilder {
        var version :UInt = 1
        var streams :[StreamInfo] = []
        var start :StartIndicator?
        var independentSegments :Bool = false
        var renditions :[Rendition] = []
        
        var fatalTag :AnyTag?
        init() {
            start = nil
        }
    }
    
    let playlistBuilder = tags.reduce(PlaylistBuilder(), { (state: PlaylistBuilder, tag: AnyTag) -> PlaylistBuilder in
        
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
                break
            }
            break
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
                // print("\(attributes)\(url)")
            case let .iFramesStreamInfo(attributes):
                // TODO: iFrame Stream Info
                log("Unprocessed iFrame Stream Info :: \(attributes)", level: .error)
            case let .sessionData(attributes):
                // TODO: Session Data
                log("Unprocessed Session Data :: \(attributes)", level: .error)
            case let .sessionKey(attributes):
                // TODO: Session Key
                log("Unprocessed Session Key :: \(attributes)", level: .error)
            }
        }
        
        return returnState
    })
    
    let streams = playlistBuilder.streams.map({
        StreamInfo(bandwidth: $0.bandwidth, averageBandwidth: $0.averageBandwidth, codecs: $0.codecs, resolution: $0.resolution, frameRate: $0.frameRate, uri: URL(string: $0.uri.absoluteString, relativeTo: url )!)
    })

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
    
    return MasterPlaylist(version: playlistBuilder.version, uri: url, streams: streams, renditions: renditions, start: playlistBuilder.start)
}
