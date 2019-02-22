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

enum HLS {

    // MARK: Basic Tags

    enum Playlist {

        static let TagParser = AnyTag.playlist <^> EXTVERSION
            <|> EXTXINDEPENDENTSEGMENTS
            <|> URLPseudoTag
            <|> COMMENT

        static let StartTag: Parser<Substring, String> = "#EXTM3U"

        static let EXTVERSION = Tag.version <^> "#EXT-X-VERSION:" *> UInt.parser

        static let EXTXINDEPENDENTSEGMENTS = { _ in Tag.independentSegments } <^> "#EXT-X-INDEPENDENT-SEGMENTS"

        static let EXTXSTART = Tag.startIndicator <^> ( StartIndicator.init <^!> ( "#EXT-X-START:" *> attributeList ))


        static let COMMENT = Tag.comment <^> "#" *> ({ (chars: [Character]) in String(chars) } <^> CharacterSet(charactersIn: "\r\n").inverted.parser().many)

        static let URLPseudoTag = Tag.url <^> TypeParser.url

        enum Master {
            static let TagParser = MasterTagParser <|> Playlist.TagParser

            static let MasterTagParser = AnyTag.master <^> EXTXMEDIA
                <|> EXTXSTREAMINF
                <|> EXTXIFRAMESTREAMINF
                <|> EXTXSESSIONDATA
                <|> EXTXSESSIONKEY
            
            static let EXTXMEDIA = Tag.MasterPlaylist.media <^> ( Rendition.init <^!> "#EXT-X-MEDIA:" *> attributeList)

            static let EXTXSTREAMINF = Tag.MasterPlaylist.streamInfo <^> ( StreamInfo.init <^!>  "#EXT-X-STREAM-INF:" *> attributeList <* BasicParser.newline.many <&> TypeParser.url)

            static let EXTXIFRAMESTREAMINF = Tag.MasterPlaylist.iFramesStreamInfo <^> "#EXT-X-I-FRAME-STREAM-INF:" *> attributeList

            static let EXTXSESSIONDATA = Tag.MasterPlaylist.sessionData <^> "#EXT-X-SESSION-DATA:" *> attributeList

            static let EXTXSESSIONKEY = Tag.MasterPlaylist.sessionKey <^> "#EXT-X-SESSION-KEY:" *> attributeList
        }

        enum Media {

            static let TagParser = MediaTagParser <|> Segment.TagParser <|> Playlist.TagParser

            static let MediaTagParser = AnyTag.media <^> EXTXTARGETDURATION
                <|> EXTXMEDIASEQUENCE
                <|> EXTXDISCONTINUITYSEQUENCE
                <|> EXTXENDLIST
                <|> EXTXPLAYLISTTYPE
                <|> EXTXIFRAMESONLY

            static let EXTXTARGETDURATION = Tag.MediaPlaylist.targetDuration <^> "#EXT-X-TARGETDURATION:" *> decimalInteger

            static let EXTXMEDIASEQUENCE = Tag.MediaPlaylist.mediaSequence <^> "#EXT-X-MEDIA-SEQUENCE:" *> decimalInteger

            static let EXTXDISCONTINUITYSEQUENCE = Tag.MediaPlaylist.discontinuitySequence <^> "#EXT-X-DISCONTINUITY-SEQUENCE:" *> decimalInteger

            static let EXTXENDLIST = { _ in Tag.MediaPlaylist.endList } <^> "#EXT-X-ENDLIST"

            static let EXTXPLAYLISTTYPE = Tag.MediaPlaylist.playlistType <^> "#EXT-X-PLAYLIST-TYPE:" *> enumeratedString

            static let EXTXIFRAMESONLY = { _ in Tag.MediaPlaylist.iFramesOnly } <^> "#EXT-X-I-FRAMES-ONLY"

            enum Segment {

                static let TagParser = AnyTag.segment <^> EXTINF
                    <|> EXTXBYTERANGE
                    <|> EXTXDISCONTINUITY
                    <|> EXTXKEY
                    <|> EXTXMAP
                    <|> EXTXPROGRAMDATETIME
                    <|> EXTXDATERANGE

                static let EXTINF = Tag.MediaPlaylist.Segment.inf <^>
                    "#EXTINF:" *> (( decimalFloatingPoint <|> decimalInteger ) <* ","
                    <&> ({ String($0) } <^> (CharacterSet.newlines.inverted).parser().many1).optional)

                static let EXTXBYTERANGE = Tag.MediaPlaylist.Segment.byteRange <^> ( "#EXT-X-BYTERANGE:" *> TypeParser.byteRange )

                static let EXTXDISCONTINUITY = { _ in Tag.MediaPlaylist.Segment.discontinuity } <^> "#EXT-X-DISCONTINUITY"

                static let EXTXKEY = Tag.MediaPlaylist.Segment.key <^> (DecryptionKey.init <^!> "#EXT-X-KEY:" *> attributeList )

                static let EXTXMAP = Tag.MediaPlaylist.Segment.map <^> ( MediaInitializationSection.init <^!> "#EXT-X-MAP:" *> attributeList )

                static let EXTXPROGRAMDATETIME = Tag.MediaPlaylist.Segment.programDateTime <^> "#EXT-X-PROGRAM-DATE-TIME:" *> TypeParser.date

                static let EXTXDATERANGE = Tag.MediaPlaylist.Segment.dateRange <^> "#EXT-X-DATERANGE:" *> attributeList
            }


        }

    }

}
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

    case comment(String)

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
