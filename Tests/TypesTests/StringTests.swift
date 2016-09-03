//
//  StringTests.swift
//  HLSCore
//
//  Created by Fabian Canas on 8/21/16.
//  Copyright © 2016 Fabian Canas. All rights reserved.
//

import XCTest
@testable import Types

class StringTests: XCTestCase {
    
    func testFullRange() {
        let emptyString :String = ""
        let singleCharacter :String = "A"
        let multipleLines :String = "Something on\nmultiple lines\nis good to test."
        let basic :String = "Some basic string"
        
        let allStrings = [emptyString, singleCharacter, multipleLines, basic]
        
        for s in allStrings {
            XCTAssertEqual(s, s.substring(with: s.fullRange))
        }
    }
    
    func testdeepestDirectoryPath() {
        let f = "/path/with/file"
        XCTAssertEqual(f.deepestDirectoryPath(), "/path/with/")
        
        let d = "/path/without/file/"
        XCTAssertEqual(d.deepestDirectoryPath(), "/path/without/file/")
    }
    
    static var allTests : [(String, (StringTests) -> () throws -> Void)] {
        return [
            ("testFullRange", testFullRange),
            ("testdeepestDirectoryPath", testdeepestDirectoryPath),
        ]
    }
    
}
