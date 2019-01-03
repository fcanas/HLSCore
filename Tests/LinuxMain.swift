import XCTest
@testable import HLSCoreTestSuite

XCTMain([
     testCase(
        HLSCoreTests.allTests +
        RenditionGroupTests.allTests
    )
])
