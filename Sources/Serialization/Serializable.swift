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

public struct MediaPlaylistSerializer : Serializer {
    
    let usesRelativeURI :Bool = true
    
    let newline :LineEnding = .CR
    
    typealias SerializationFormat = StringResource
    typealias Input = MediaPlaylist
    
    public func serialize(_ playlist: MediaPlaylist) -> StringResource {
        var output = "#EXTM3U" // required first line
        
        output = output._append("#EXT-X-TARGETDURATION:\(Int(playlist.targetDuration))", line: newline)
        
        if playlist.version > 1 {
            output = output._append("#EXT-X-VERSION:\(Int(playlist.version))", line: newline)
        }

        if playlist.mediaSequence != 0 {
            output = output._append("#EXT-X-MEDIA-SEQUENCE:\(playlist.mediaSequence)", line: newline)
        }

        if let type = playlist.type {
            output = output._append("#EXT-X-PLAYLIST-TYPE:\(type)", line: newline)
        }
        
        var decryptionKey :DecryptionKey? = nil
        
        var lastOutputMediaInitialization: MediaInitializationSection?

        if playlist.independentSegments {
            output = output._append("#EXT-X-INDEPENDENT-SEGMENTS", line: newline)
        }

        for segment in playlist.segments {

            if let smi = segment.mediaInitializationSection, smi != lastOutputMediaInitialization {
                var tagString = "#EXT-X-MAP:URI=\"\(smi.uri.relativeString)\""
                if let byteRange = smi.byteRange {
                    tagString = tagString + ",BYTERANGE=\"\(byteRange.distance(from: byteRange.startIndex, to: byteRange.endIndex) - 1)@\(byteRange.first!)\""
                }
                output = output._append(tagString, line: newline)
                lastOutputMediaInitialization = smi
            }

            if segment.decryptionKey != decryptionKey {
                decryptionKey = segment.decryptionKey
                if let key = decryptionKey {
                    output = output._append(key.playlistString, line: newline)
                } else {
                    output = output._append(DecryptionKey.None.playlistString, line: newline)
                }
            }
            output = output._append("#EXTINF:\(segment.duration),", line: newline)
            if let byteRange = segment.byteRange, let start = byteRange.first {
                let length = byteRange.distance(from: byteRange.startIndex, to: byteRange.endIndex)
                output = output._append("#EXT-X-BYTERANGE:\(length-1)@\(start)", line: newline)
            }
            output = output._append(segment.resource.uri.relativeString, line: newline)
        }
        
        output += "\n"
        
        return Resource(uri: playlist.uri, value: output)
    }
    
    public init() {}
}

private extension DecryptionKey {
    
    var playlistString :String {
        get {
            var out = "#EXT-X-KEY:METHOD=\(method.rawValue)"
            if method != .None {
                out += ",URI=\"\(uri)\""
                
                if let iv = initializationVector {
                    out += String(format:",%8x%8x", iv.high, iv.low)
                }
                if keyFormat != "identity" {
                    out += "," + keyFormat
                }
                if let v = keyFormatVersions {
                    out += "," + v.map({ String($0) }).joined(separator: "/")
                }
            }
            return out
        }
    }
    
}
