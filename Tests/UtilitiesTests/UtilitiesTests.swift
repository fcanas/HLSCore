//  Copyright © 2016 Fabian Canas. All rights reserved.

import XCTest
@testable import Utilities

class StringExtensionTests: XCTestCase {
    
    func testFullRange() {
        let emptyString :NSString = ""
        let singleCharacter :NSString = "A"
        let multipleLines :NSString = "Something on\nmultiple lines\nis good to test."
        let basic :NSString = "Some basic string"
        
        let allStrings = [emptyString, singleCharacter, multipleLines, basic]
        
        for s in allStrings {
            XCTAssertEqual(s as String, s.substring(with: s.fullRange))
        }
    }
    
    func testdeepestDirectoryPath() {
        let f = "/path/with/file"
        XCTAssertEqual(f.deepestDirectoryPath(), "/path/with/")
        
        let d = "/path/without/file/"
        XCTAssertEqual(d.deepestDirectoryPath(), "/path/without/file/")
    }
    
}
