import XCTest
@testable import HLSCore

class HLSCoreTests: XCTestCase {
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        XCTAssertEqual(HLSCore().text, "Hello, World!")
    }


    static var allTests : [(String, (HLSCoreTests) -> () throws -> Void)] {
        return [
            ("testExample", testExample),
        ]
    }
}
