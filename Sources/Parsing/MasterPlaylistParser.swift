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
        var uri :URL?
        var streams :[MediaPlaylist] = []
        var start :StartIndicator?
    }
    
    let builder = tags.reduce(PlaylistBuilder(), { (state: PlaylistBuilder, tag: AnyTag) -> PlaylistBuilder in
        return state
    })
    
    guard let uri = builder.uri else {
        return nil
    }
    
    return MasterPlaylist(version: builder.version, uri: uri, streams: builder.streams, start: builder.start)
}
