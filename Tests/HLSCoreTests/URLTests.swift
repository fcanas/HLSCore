//
//  URLTests.swift
//  HLSCore
//
//  Created by Fabian Canas on 8/19/16.
//  Copyright © 2016 Fabian Canas. All rights reserved.
//

import XCTest
@testable import HLSCore

class URLTests: XCTestCase {
    func testRelativeURL() {
        let toRelative = URL(string: "http://example.com/test/thing")!
        let base = URL(string: "http://example.com/test/")!
        
        let newRealtive = toRelative.relativeURL(baseURL: base)
        
        XCTAssertEqual(newRealtive.relativeString, "thing")
        XCTAssertEqual(newRealtive, URL(string: "thing", relativeTo: base))
    }
    
    static var allTests : [(String, (URLTests) -> () throws -> Void)] {
        return [
            ("testRelativeURL", testRelativeURL),
        ]
    }
}
