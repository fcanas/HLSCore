//
//  Playlist.swift
//  FFCParserCombinator
//
//  Created by Fabian Canas on 4/11/18.
//

import Foundation
import FFCParserCombinator
import Types

/// The first tag
let PlaylistStart :Parser<String> = "#EXTM3U"

let URLPseudoTag = Tag.url <^> TypeParser.url

// MARK: Aggregate Tags

let MediaPlaylistTag = ExclusiveMediaPlaylistTag <|> SegmentTag <|> PlaylistTag

let MasterPlaylistTag = ExclusiveMasterPlaylistTag <|> PlaylistTag

let PlaylistTag = AnyTag.playlist <^> EXTVERSION
                                  <|> EXTXINDEPENDENTSEGMENTS
                                  <|> URLPseudoTag
                                  <|> COMMENT

let SegmentTag = AnyTag.segment <^> EXTINF
                                <|> EXTXBYTERANGE
                                <|> EXTXDISCONTINUITY
                                <|> EXTXKEY
                                <|> EXTXMAP
                                <|> EXTXPROGRAMDATETIME
                                <|> EXTXDATERANGE

let ExclusiveMediaPlaylistTag = AnyTag.media <^> EXTXTARGETDURATION
                                             <|> EXTXMEDIASEQUENCE
                                             <|> EXTXDISCONTINUITYSEQUENCE
                                             <|> EXTXENDLIST
                                             <|> EXTXPLAYLISTTYPE
                                             <|> EXTXIFRAMESONLY

let ExclusiveMasterPlaylistTag = AnyTag.master <^> EXTXMEDIA
                                               <|> EXTXSTREAMINF
                                               <|> EXTXIFRAMESTREAMINF
                                               <|> EXTXSESSIONDATA
                                               <|> EXTXSESSIONKEY
