//
//  TagTests.swift
//  HLSCore
//
//  Created by Fabian Canas on 9/17/16.
//
//

import XCTest
import Types
@testable import Parsing

class StartTagTests: XCTestCase {
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
