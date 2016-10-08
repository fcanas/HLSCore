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
        let (startIndicator, _) = EXTXSTART.run(tag)!
        XCTAssertEqual(startIndicator, StartIndicator(at: startTime))
    }
    
    func testExplicitNotPrecise() {
        let startTime :TimeInterval = 1.3
        let tag = "#EXT-X-START:TIME-OFFSET=\(startTime),PRECISE=NO"
        let (startIndicator, _) = EXTXSTART.run(tag)!
        XCTAssertEqual(startIndicator, StartIndicator(at: startTime))
    }
    
    func testExplicitPrecise() {
        let startTime :TimeInterval = 1.3
        let tag = "#EXT-X-START:TIME-OFFSET=\(startTime),PRECISE=YES"
        let (startIndicator, _) = EXTXSTART.run(tag)!
        XCTAssertEqual(startIndicator, StartIndicator(at: startTime, preciseStart: true))
    }
    
}

class MediaSegmentParsingTests: XCTestCase {
    
    func testBasicMediaSegment() {
        let urlString = "http://example.com/"
        let duration = 1.03
        let infoTag = "#EXTINF:\(duration),\n\(urlString)"
        let (mediaSegment, _) = MediaEntityParser.run(infoTag)!
        let segment = MediaSegment(uri: URL(string:urlString)!, duration: duration)
        XCTAssertEqual(mediaSegment, segment)
    }
    
    func testMediaSegmentWithTitle() {
        let urlString = "http://example.com/"
        let duration = 1.25
        let title = "A title, which can be any UTF8 without linebreaks? 🐐"
        let infoTag = "#EXTINF:\(duration),\(title)\n\(urlString)"
        let (mediaSegment, _) = MediaEntityParser.run(infoTag)!
        let segment = MediaSegment(uri: URL(string:urlString)!, duration: duration, title: title)
        XCTAssertEqual(mediaSegment, segment)
    }
    
    func testMediaSegmentWithTitleAndSimpleByteRange() {
        let urlString = "http://example.com/"
        let duration = 1.25
        let title = "A title, which can be any UTF8 without linebreaks? 🐐"
        let infoTag = "#EXTINF:\(duration),\(title)\n#EXT-X-BYTERANGE:1234\n\(urlString)"
        let (mediaSegment, _) = MediaEntityParser.run(infoTag)!
        let segment = MediaSegment(uri: URL(string:urlString)!, duration: duration, title: title, byteRange: 0...1234)
        XCTAssertEqual(mediaSegment, segment)
    }
    
    func testMediaSegmentWithTitleAndFullyQualifiedByteRange() {
        let urlString = "http://example.com/"
        let duration = 1.25
        let title = "A title, which can be any UTF8 without linebreaks? 🐐"
        let infoTag = "#EXTINF:\(duration),\(title)\n#EXT-X-BYTERANGE:1234@5678\n\(urlString)"
        let (mediaSegment, _) = MediaEntityParser.run(infoTag)!
        let segment = MediaSegment(uri: URL(string:urlString)!, duration: duration, title: title, byteRange: 5678...6912)
        XCTAssertEqual(mediaSegment, segment)
    }
    
}

class DateTimeTagTests: XCTestCase {
    @available (OSX 10.12, *)
    func testBasicDateTag() {
        let date = Date(timeIntervalSinceReferenceDate: 496636022)
        let timeString = ISO8601DateFormatter().string(from: date)
        let dateTag = "#EXT-X-PROGRAM-DATE-TIME:\(timeString)"
        let (parsedDate, _) = EXTXPROGRAMDATETIME.run(dateTag)!
        XCTAssertEqual(parsedDate, date)
    }
    
}

