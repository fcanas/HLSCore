//
//  Serializable.swift
//  HLSCore
//
//  Created by Fabian Canas on 8/14/16.
//  Copyright © 2016 Fabian Canas. All rights reserved.
//

import Foundation
import Types

public struct Resource <T> {
    public let uri :URL
    public let value :T?
}

public typealias StringResource = Resource<String>

protocol Serializer {
    associatedtype SerializationFormat
    associatedtype Input
    func serialize(_: Input) -> SerializationFormat
}

enum LineEnding :String {
    case CR = "\n"
    case CRLF = "\r\n"
}

extension String {
    func _append(_ addendum: String, line: LineEnding) -> String {
        return self + line.rawValue + addendum
    }
}

public struct MediaPlaylistSerlializer : Serializer {
    
    let usesRelativeURI :Bool = true
    
    let newline :LineEnding = .CR
    
    typealias SerializationFormat = StringResource
    typealias Input = MediaPlaylist
    
    public func serialize(_ playlist: MediaPlaylist) -> StringResource {
        var output = "#EXTM3U" // required first line
        
        output = output._append("#EXT-TARGET-DURATION:\(Int(playlist.targetDuration))", line: newline)
        
        if playlist.version > 1 {
            output = output._append("#EXT-X-VERSION:\(Int(playlist.version))", line: newline)
        }
        
        if let type = playlist.type {
            output = output._append("#EXT-X-PLAYLIST-TYPE:\(type)", line: newline)
        }
        
        for segment in playlist.segments {
            output = output._append("#EXTINF:\(segment.duration)", line: newline)
            output = output._append(segment.resource.uri.relativeString, line: newline)
        }
        
        output += "\n"
        
        return Resource(uri: playlist.uri, value: output)
    }
    
    public init() {}
}
