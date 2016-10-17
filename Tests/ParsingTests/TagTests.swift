//
//  TagTests.swift
//  HLSCore
//
//  Created by Fabian Canas on 9/17/16.
//  Copyright © 2016 Fabian Canas. All rights reserved.
//

import XCTest
import Types
@testable import Parsing

class StartTagParsingTests: XCTestCase {
    
    func testTimeOffset() {
        let startTime :TimeInterval = 1.3
        let tag = "#EXT-X-START:TIME-OFFSET=\(startTime)"
        let (parsedTag, _) = EXTXSTART.run(tag)!
        let startIndicator = entity(fromTag: AnyTag.playlist(parsedTag)) as! StartIndicator
        XCTAssertEqual(startIndicator, StartIndicator(at: startTime))
    }
    
    func testExplicitNotPrecise() {
        let startTime :TimeInterval = 1.3
        let tag = "#EXT-X-START:TIME-OFFSET=\(startTime),PRECISE=NO"
        let (parsedTag, _) = EXTXSTART.run(tag)!
        let startIndicator = entity(fromTag: AnyTag.playlist(parsedTag)) as! StartIndicator
        XCTAssertEqual(startIndicator, StartIndicator(at: startTime))
    }
    
    
    func testExplicitPrecise() {
        let startTime :TimeInterval = 1.3
        let tag = "#EXT-X-START:TIME-OFFSET=\(startTime),PRECISE=YES"
        let (parsedTag, _) = EXTXSTART.run(tag)!
        let startIndicator = entity(fromTag: AnyTag.playlist(parsedTag)) as! StartIndicator
        XCTAssertEqual(startIndicator, StartIndicator(at: startTime, preciseStart: true))
    }
    
}

class ParsingTests: XCTestCase {
    func testBasicPlaylist() {
        
        let inputPlaylist =
                "#EXTM3U" + "\n" +
                "#EXT-X-PLAYLIST-TYPE:VOD" + "\n" +
                "#EXT-X-TARGETDURATION:3" + "\n" +
                "#EXT-X-VERSION:3" + "\n" +
                "#EXTINF:3.1," + "\n" +
                "s1.ts" + "\n" +
                "#EXTINF:3.0," + "\n" +
                "s2.ts" + "\n" +
                "#EXTINF:3.2," + "\n" +
                "../s3.ts" + "\n" +
                "#EXTINF:2.9," + "\n" +
                "alt/s4.ts" + "\n" +
                "#EXT-X-KEY:METHOD=AES-128,URI=\"ex.key\"" + "\n" +
                "#EXTINF:3.0," + "\n" +
                "s5.ts" + "\n" +
                "#EXTINF:3.2," + "\n" +
                "s6.ts" + "\n" +
                "#EXT-X-ENDLIST" + "\n"

        let urlString = "http://example.com/test/playlist.m3u8"
        let url = URL(string: urlString)!
        
        let s1URL = URL(string: "http://example.com/test/s1.ts")!
        let s2URL = URL(string: "s2.ts", relativeTo: url)!
        let s3URL = URL(string: "http://example.com/s3.ts")!
        let s4URL = URL(string: "http://example.com/test/alt/s4.ts")!
        let s5URL = URL(string: "s5.ts", relativeTo: url)!
        let s6URL = URL(string: "s6.ts", relativeTo: url)!
        
        let segments = [MediaSegment(uri: s1URL, duration: 3.1),
                        MediaSegment(uri: s2URL, duration: 3.0),
                        MediaSegment(uri: s3URL, duration: 3.2),
                        MediaSegment(uri: s4URL, duration: 2.9)]
        
        let unencryptedSegments =  [MediaSegment(uri: s5URL, duration: 3.0),
                                    MediaSegment(uri: s6URL, duration: 3.2)]
        let key = DecryptionKey(method:.AES128, uri:URL(string:"ex.key")!)
        let encryptedSegments = setDecryptionKey(key, forSegments: unencryptedSegments)
        
        let playlist :MediaPlaylist = MediaPlaylist(type: .VOD, version: 3, uri: url, targetDuration: 3, closed: true, start: nil, segments: segments + encryptedSegments)
        
        
        
        let parsedPlaylist = parseMediaPlaylist(string: inputPlaylist, atURL: url)
        
        XCTAssertEqual(playlist, parsedPlaylist)
    }
    
    static var allTests : [(String, (ParsingTests) -> () throws -> Void)] {
        return [
            ("testBasicPlaylist", testBasicPlaylist),
        ]
    }
}


/*
 
class DateTimeTagTests: XCTestCase {
    @available (OSX 10.12, *)
    func testBasicDateTag() {
        let date = Date(timeIntervalSinceReferenceDate: 496636022)
        let timeString = ISO8601DateFormatter().string(from: date)
        let dateTag = "#EXT-X-PROGRAM-DATE-TIME:\(timeString)"
        let (parsedDate, _) = EXTXPROGRAMDATETIME.run(dateTag)!
        let dateTime = entity(fromTag: AnyTag.segment(parsedDate))
        XCTAssertEqual(parsedDate, date)
    }
    
}
 
class MediaSegmentParsingTests: XCTestCase {
    
    func testBasicMediaSegment() {
        let urlString = "http://example.com/"
        let duration = 1.03
        let infoTag = "#EXTINF:\(duration),\n\(urlString)"
        let (mediaSegment, _) = MediaSegmentParser.run(infoTag)!
        let segment = MediaSegment(uri: URL(string:urlString)!, duration: duration)
        XCTAssertEqual(mediaSegment, segment)
    }
    
    func testMediaSegmentWithTitle() {
        let urlString = "http://example.com/"
        let duration = 1.25
        let title = "A title, which can be any UTF8 without linebreaks? 🐐"
        let infoTag = "#EXTINF:\(duration),\(title)\n\(urlString)"
        let (mediaSegment, _) = MediaSegmentParser.run(infoTag)!
        let segment = MediaSegment(uri: URL(string:urlString)!, duration: duration, title: title)
        XCTAssertEqual(mediaSegment, segment)
    }
    
    func testMediaSegmentWithTitleAndSimpleByteRange() {
        let urlString = "http://example.com/"
        let duration = 1.25
        let title = "A title, which can be any UTF8 without linebreaks? 🐐"
        let infoTag = "#EXTINF:\(duration),\(title)\n#EXT-X-BYTERANGE:1234\n\(urlString)"
        let (mediaSegment, _) = MediaSegmentParser.run(infoTag)!
        let segment = MediaSegment(uri: URL(string:urlString)!, duration: duration, title: title, byteRange: 0...1234)
        XCTAssertEqual(mediaSegment, segment)
    }
    
    func testMediaSegmentWithTitleAndFullyQualifiedByteRange() {
        let urlString = "http://example.com/"
        let duration = 1.25
        let title = "A title, which can be any UTF8 without linebreaks? 🐐"
        let infoTag = "#EXTINF:\(duration),\(title)\n#EXT-X-BYTERANGE:1234@5678\n\(urlString)"
        let (mediaSegment, _) = MediaSegmentParser.run(infoTag)!
        let segment = MediaSegment(uri: URL(string:urlString)!, duration: duration, title: title, byteRange: 5678...6912)
        XCTAssertEqual(mediaSegment, segment)
    }
 
}
*/
