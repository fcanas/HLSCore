//
//  Tags.swift
//  HLSCore
//
//  Created by Fabian Canas on 9/5/16.
//  Copyright © 2016 Fabian Canas. All rights reserved.
//

import Foundation
import Types
import FFCParserCombinator

/// The first tag
let PlaylistStart :Parser<String> = "#EXTM3U"

let URLPseudoTag = Tag.url <^> TypeParser.url

// MARK: Aggregate Tags

let MediaPlaylistTag = ExclusiveMediaPlaylistTag <|> SegmentTag <|> PlaylistTag

let MasterPlaylistTag = ExclusiveMasterPlaylistTag <|> PlaylistTag

let PlaylistTag = AnyTag.playlist <^> EXTVERSION <|>
                                      EXTXINDEPENDENTSEGMENTS <|>
                                      URLPseudoTag

let SegmentTag = AnyTag.segment <^> EXTINF <|>
                                    EXTXBYTERANGE <|>
                                    EXTXDISCONTINUITY <|>
                                    EXTXKEY <|>
                                    EXTXMAP <|>
                                    EXTXPROGRAMDATETIME <|>
                                    EXTXDATERANGE

let ExclusiveMediaPlaylistTag = AnyTag.media <^> EXTXTARGETDURATION <|>
                                                 EXTXMEDIASEQUENCE <|>
                                                 EXTXDISCONTINUITYSEQUENCE <|>
                                                 EXTXENDLIST <|>
                                                 EXTXPLAYLISTTYPE <|>
                                                 EXTXIFRAMESONLY

let ExclusiveMasterPlaylistTag = AnyTag.master <^> EXTXMEDIA <|>
                                                   EXTXSTREAMINF <|>
                                                   EXTXIFRAMESTREAMINF <|>
                                                   EXTXSESSIONDATA <|>
                                                   EXTXSESSIONKEY

// MARK: Basic Tags

let EXTVERSION = Tag.version <^> "#EXT-X-VERSION:" *> BasicParser.int

let EXTXINDEPENDENTSEGMENTS = { _ in Tag.independentSegments } <^> ("#EXT-X-INDEPENDENT-SEGMENTS" as Parser<String>)

let EXTXSTART = Tag.startIndicator <^> ( StartIndicator.init <^!> ( "#EXT-X-START:" *> attributeList ))

// MARK: Media Segment Tags

let EXTINF = Tag.MediaPlaylist.Segment.inf <^> "#EXTINF:" *> (( decimalFloatingPoint <|> decimalInteger ) <* character { $0 == "," } <&> ({ (characters :[Character]) -> String in return String(characters) } <^!> (CharacterSet.newlines.inverted).parser().many))

let EXTXBYTERANGE = Tag.MediaPlaylist.Segment.byteRange <^> ( "#EXT-X-BYTERANGE:" *> TypeParser.byteRange )

let EXTXDISCONTINUITY = { _ in Tag.MediaPlaylist.Segment.discontinuity } <^> "#EXT-X-DISCONTINUITY"

let EXTXKEY = Tag.MediaPlaylist.Segment.key <^> (DecryptionKey.init <^!> "#EXT-X-KEY:" *> attributeList )

let EXTXMAP = Tag.MediaPlaylist.Segment.map <^> ( MediaInitializationSection.init <^!> "#EXT-X-MAP:" *> attributeList )

let EXTXPROGRAMDATETIME = Tag.MediaPlaylist.Segment.programDateTime <^> "#EXT-X-PROGRAM-DATE-TIME:" *> TypeParser.date

let EXTXDATERANGE = Tag.MediaPlaylist.Segment.dateRange <^> "#EXT-X-DATERANGE:" *> attributeList

// MARK: Media Playlist Tags

let EXTXTARGETDURATION = Tag.MediaPlaylist.targetDuration <^> "#EXT-X-TARGETDURATION:" *> decimalInteger

let EXTXMEDIASEQUENCE = Tag.MediaPlaylist.mediaSequence <^> "#EXT-X-MEDIA-SEQUENCE:" *> decimalInteger

let EXTXDISCONTINUITYSEQUENCE = Tag.MediaPlaylist.discontinuitySequence <^> "#EXT-X-DISCONTINUITY-SEQUENCE:" *> decimalInteger

let EXTXENDLIST = { _ in Tag.MediaPlaylist.endList } <^> "#EXT-X-ENDLIST"

let EXTXPLAYLISTTYPE = Tag.MediaPlaylist.playlistType <^> "#EXT-X-PLAYLIST-TYPE:" *> enumeratedString

let EXTXIFRAMESONLY = { _ in Tag.MediaPlaylist.iFramesOnly } <^> "#EXT-X-I-FRAMES-ONLY"

// MARK: Master Playlist Tags

let EXTXMEDIA = Tag.MasterPlaylist.media <^> ( Rendition.init <^!> "#EXT-X-MEDIA:" *> attributeList)

let EXTXSTREAMINF = Tag.MasterPlaylist.streamInfo <^> ( StreamInfo.init <^!>  "#EXT-X-STREAM-INF:" *> attributeList <* BasicParser.newline.many <&> TypeParser.url)

let EXTXIFRAMESTREAMINF = Tag.MasterPlaylist.iFramesStreamInfo <^> "#EXT-X-I-FRAME-STREAM-INF:" *> attributeList

let EXTXSESSIONDATA = Tag.MasterPlaylist.sessionData <^> "#EXT-X-SESSION-DATA:" *> attributeList

let EXTXSESSIONKEY = Tag.MasterPlaylist.sessionKey <^> "#EXT-X-SESSION-KEY:" *> attributeList

// MARK: Tag Taxonomy

enum AnyTag {
    case playlist(Tag)
    case media(Tag.MediaPlaylist)
    case segment(Tag.MediaPlaylist.Segment)
    case master(Tag.MasterPlaylist)
}

enum Tag {
    
    case version(UInt)
    
    case independentSegments
    case startIndicator(StartIndicator)
    
    /// Not a tag, but definitely a top-level element. Makes parsing easier.
    case url(URL)
    
    enum MediaPlaylist {
        case targetDuration(AttributeValue)
        case mediaSequence(AttributeValue)
        case discontinuitySequence(AttributeValue)
        case endList
        case playlistType(AttributeValue)
        case iFramesOnly
        
        enum Segment {
            case inf(AttributeValue, String?)
            case byteRange(CountableClosedRange<UInt>)
            case discontinuity
            
            case key(DecryptionKey)
            case map(MediaInitializationSection)
            
            case programDateTime(Date?)
            case dateRange(AttributeList)
        }
    }
    
    enum MasterPlaylist {
        case media(Rendition)
        case streamInfo(StreamInfo)
        case iFramesStreamInfo(AttributeList)
        case sessionData(AttributeList)
        case sessionKey(AttributeList)
    }
}

