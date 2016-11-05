//
//  MasterPlaylistParser.swift
//  HLSCore
//
//  Created by Fabian Canas on 10/22/16.
//  Copyright © 2016 Fabian Canas. All rights reserved.
//

import Foundation
import Types

public func parseMasterPlaylist(string: String, atURL url: URL) -> MasterPlaylist? {
    let parser = PlaylistStart *> newlines *> ( MasterPlaylistTag <* newlines ).many
    
    let parseResult = parser.run(string)
    
    if let remainingChars = parseResult?.1 {
        print("REMAINDER:\n\(String(remainingChars))")
    }
    
    guard let tags = parseResult?.0 else {
        return nil
    }
    
    struct PlaylistBuilder {
        var version :UInt = 1
        var streams :[StreamInfo] = []
        var start :StartIndicator?
        var independentSegments :Bool = false
        
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
            case let .startIndicator(attributes):
                returnState.start = StartIndicator(attributes: attributes)
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
            case let .media(attributes):
                print(attributes)
            case let .streamInfo(attributes, url):
                let streamInfo = StreamInfo(attributes: attributes, uri: url)
                guard let stream = streamInfo else {
                    returnState.fatalTag = tag
                    break
                }
                returnState.streams.append(stream)
                print("\(attributes)\(url)")
            case let .iFramesStreamInfo(attributes):
                // TODO: iFrame Stream Info
                print(attributes)
            case let .sessionData(attributes):
                // TODO: Session Data
                print(attributes)
            case let .sessionKey(attributes):
                // TODO: Session Key
                print(attributes)
            }
        }
        
        return returnState
    })
    
    
    return MasterPlaylist(version: playlistBuilder.version, uri: url, streams: playlistBuilder.streams, start: playlistBuilder.start)
}
