//  Copyright © 2016 Fabian Canas. All rights reserved.

import XCTest
@testable import Types

class StringExtensionTests: XCTestCase {

    func testFullRange() {
        let emptyString = ""
        let singleCharacter = "A"
        let multipleLines = "Something on\nmultiple lines\nis good to test."
        let basic = "Some basic string"

        let allStrings = [emptyString, singleCharacter, multipleLines, basic]

        for s in allStrings {
            XCTAssertEqual(s, String(s[s.fullRange]))
        }
    }

    func testdeepestDirectoryPath() {
        let f = "/path/with/file"
        XCTAssertEqual(f.deepestDirectoryPath(), "/path/with/")

        let d = "/path/without/file/"
        XCTAssertEqual(d.deepestDirectoryPath(), "/path/without/file/")
    }

}
