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

func entity(fromTag tag: AnyTag) -> Any? {

    switch tag {
    case let .playlist(playlist):
        switch playlist {
        case .version(_):
            return nil
        case .independentSegments:
            return nil
        case let .startIndicator(startIndicator):
            return startIndicator
        case .url(_):
            return nil
        case .comment(_):
            return nil
        }
    case .media(_):
        return nil
    case let .segment(segment):
        switch segment {
        case .inf(_, _):
            return nil
        case .byteRange(_):
            return nil
        case .discontinuity:
            return nil
        case let .key(key):
            return key
        case .map(_):
            return nil
        case .programDateTime(_):
            return nil
        case .dateRange(_):
            return nil
        }
    case .master(_):
        return nil
    }

}

class StartTagParsingTests: XCTestCase {

    func testTimeOffset() {
        let startTime: TimeInterval = 1.3
        let tag = "#EXT-X-START:TIME-OFFSET=\(startTime)"
        let (parsedTag, _) = HLS.Playlist.EXTXSTART.run(tag)!
        let startIndicator = entity(fromTag: AnyTag.playlist(parsedTag)) as! StartIndicator
        XCTAssertEqual(startIndicator, StartIndicator(at: startTime))
    }

    func testExplicitNotPrecise() {
        let startTime: TimeInterval = 1.3
        let tag = "#EXT-X-START:TIME-OFFSET=\(startTime),PRECISE=NO"
        let (parsedTag, _) = HLS.Playlist.EXTXSTART.run(tag)!
        let startIndicator = entity(fromTag: AnyTag.playlist(parsedTag)) as! StartIndicator
        XCTAssertEqual(startIndicator, StartIndicator(at: startTime))
    }

    func testExplicitPrecise() {
        let startTime: TimeInterval = 1.3
        let tag = "#EXT-X-START:TIME-OFFSET=\(startTime),PRECISE=YES"
        let (parsedTag, _) = HLS.Playlist.EXTXSTART.run(tag)!
        let startIndicator = entity(fromTag: AnyTag.playlist(parsedTag)) as! StartIndicator
        XCTAssertEqual(startIndicator, StartIndicator(at: startTime, preciseStart: true))
    }

    static var allTests: [(String, (StartTagParsingTests) -> () throws -> Void)] {
        return [
            ("testTimeOffset", testTimeOffset),
            ("testExplicitNotPrecise", testExplicitNotPrecise),
            ("testExplicitPrecise", testExplicitPrecise)
        ]
    }
}
