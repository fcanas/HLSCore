//
//  URLTests.swift
//  HLSCore
//
//  Created by Fabian Canas on 8/19/16.
//  Copyright © 2016 Fabian Canas. All rights reserved.
//

import XCTest
@testable import Types

class URLTests: XCTestCase {
    func testRelativeURL() {
        let toRelative = URL(string: "http://example.com/test/thing")!
        let base = URL(string: "http://example.com/test/")!
        
        let newRealtive = toRelative.relativeURL(baseURL: base)
        
        XCTAssertEqual(newRealtive.relativeString, "thing")
        XCTAssertEqual(newRealtive, URL(string: "thing", relativeTo: base))
    }
    
    func testRelativeURLSchemeMismatch() {
        let toRelative = URL(string: "http://example.com/test/thing")!
        let base = URL(string: "ftp://example.com/test/")!
        
        let newRealtive = toRelative.relativeURL(baseURL: base)
        
        XCTAssertEqual(newRealtive.relativeString, "http://example.com/test/thing")
        XCTAssertNotEqual(newRealtive, URL(string: "thing", relativeTo: base))
    }
    
    func testRelativeURLHostMismatch() {
        let toRelative = URL(string: "http://example.com/test/thing")!
        let base = URL(string: "http://badhost.example.com/test/")!
        
        let newRealtive = toRelative.relativeURL(baseURL: base)
        
        XCTAssertEqual(newRealtive, toRelative)
        XCTAssertNotEqual(newRealtive, URL(string: "thing", relativeTo: base))
    }
    
    func testRelativeURLPortMismatch() {
        let toRelative = URL(string: "http://example.com/test/thing")!
        let base = URL(string: "http://example.com:80/test/")!
        
        let newRealtive = toRelative.relativeURL(baseURL: base)
        
        XCTAssertEqual(newRealtive, toRelative)
        XCTAssertNotEqual(newRealtive.relativeString, "thing")
        XCTAssertNotEqual(newRealtive, URL(string: "thing", relativeTo: base))
    }
    
    func testRelativeURLUserMismatch() {
        let toRelative = URL(string: "http://example.com/test/thing")!
        let base = URL(string: "http://fcanas@example.com/test/")!
        
        let newRealtive = toRelative.relativeURL(baseURL: base)
        
        XCTAssertEqual(newRealtive, toRelative)
        XCTAssertNotEqual(newRealtive.relativeString, "thing")
        XCTAssertNotEqual(newRealtive, URL(string: "thing", relativeTo: base))
    }
    
    func testRelativeDotDirectories() {
        let toRelative = URL(string: "http://example.com/test/thing")!
        let base = URL(string: "http://example.com/test/intermediate/")!
        
        let newRealtive = toRelative.relativeURL(baseURL: base)
        
        XCTAssertEqual(newRealtive.relativeString, "../thing")
        XCTAssertEqual(newRealtive, URL(string: "../thing", relativeTo: base))
    }
    
    static var allTests : [(String, (URLTests) -> () throws -> Void)] {
        return [
            ("testRelativeURL", testRelativeURL),
        ]
    }
}
