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

    func testdeepestDirectoryPath() {
        let f = "/path/with/file"
        XCTAssertEqual(f.deepestDirectoryPath(), "/path/with/")

        let d = "/path/without/file/"
        XCTAssertEqual(d.deepestDirectoryPath(), "/path/without/file/")
    }

    static var allTests: [(String, (StringTests) -> () throws -> Void)] {
        return [
            ("testdeepestDirectoryPath", testdeepestDirectoryPath)
        ]
    }

}
