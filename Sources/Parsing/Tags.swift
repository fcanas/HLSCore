//
//  Tags.swift
//  HLSCore
//
//  Created by Fabian Canas on 9/5/16.
//  Copyright © 2016 Fabian Canas. All rights reserved.
//

import Foundation
import Types

/// Basic Tags

let EXTM3U = string("#EXTM3U")

let EXTVERSION = string("#EXT-X-VERSION:") *> int

let EXTINF = string("#EXTINF:") *> (( decimalFloatingPoint <|> decimalInteger ) <&> (character { $0 == "," } *> ({ String($0) } <^> character(in: CharacterSet.alphanumerics).many))) <<& (newline *> url) <* newline

let EXTXBYTERANGE = { return ($0.1 ?? 0)...(($0.1 ?? 0) + $0.0)  } <^> string("#EXT-X-BYTERANGE:") *> int <&> (character { $0 == "@" } *> int ).optional

let EXTXDISCONTINUITY = string("#EXT-X-DISCONTINUITY")

let EXTXKEY = string("#EXT-X-KEY:") *> attributeList // needs builder

let EXTXMAP = string("#EXT-X-MAP:") *> attributeList // needs builder

let EXTXPROGRAMDATETIME = string("#EXT-X-PROGRAM-DATE-TIME:") // needs date parser : ISO 8601

let EXTXDATERANGE = string("#EXT-X-DATERANGE:") *> attributeList // needs builder with a string -> ISO 8601 parser

/// Media Playlist Tags

let EXTXTARGETDURATION = string("#EXT-X-TARGETDURATION:") *> decimalInteger

let EXTXMEDIASEQUENCE = string("#EXT-X-MEDIA-SEQUENCE:") *> decimalInteger

let EXTXDISCONTINUITYSEQUENCE = string("#EXT-X-DISCONTINUITY-SEQUENCE:") *> decimalInteger

let EXTXENDLIST = string("#EXT-X-ENDLIST")

let EXTXPLAYLISTTYPE = string("#EXT-X-PLAYLIST-TYPE:") *> enumeratedString

let EXTXIFRAMESONLY = string("#EXT-X-I-FRAMES-ONLY")

/// Master Playlist Tags

let EXTXMEDIA = string("#EXT-X-MEDIA:") *> attributeList

let EXTXSTREAMINF = string("#EXT-X-STREAM-INF:") *> attributeList <&> character { $0 == "\n" } <&> url

let EXTXIFRAMESTREAMINF = string("#EXT-X-I-FRAME-STREAM-INF:") *> attributeList

let EXTXSESSIONDATA = string("#EXT-X-SESSION-DATA:") *> attributeList

let EXTXSESSIONKEY = string("#EXT-X-SESSION-KEY:") *> attributeList

/// Master of Media Playlists

let EXTXINDEPENDENTSEGMENTS = string("#EXT-X-INDEPENDENT-SEGMENTS")

// TODO: If StartIndicator initialization fails, the parser should fail, not
//       succeed with nil.
let EXTXSTART = StartIndicator.init <^> ( string("#EXT-X-START:") *> attributeList )

