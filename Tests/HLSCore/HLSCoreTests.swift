import XCTest
@testable import HLSCore

class HLSCoreTests: XCTestCase {
    func testExample() {
        
    }
    
    static var allTests : [(String, (HLSCoreTests) -> () throws -> Void)] {
        return [
            ("testExample", testExample),
        ]
    }
}

class RenditionGroupTests: XCTestCase {
    
    func testNoDefaultRendition() {
        let renditions = [Rendition(language: Language(), name: "R1"),
                          Rendition(language: Language(), name: "R2"),
                          Rendition(language: Language(), name: "R3")]
        let group = RenditionGroup(groupId: "Group0", type: .Video, renditions: renditions)
        XCTAssertNil(group.defaultRendition)
    }
    
    func testNoForcedRenditions() {
        let renditions = [Rendition(language: Language(), name: "R1"),
                          Rendition(language: Language(), name: "R2"),
                          Rendition(language: Language(), name: "R3")]
        let group = RenditionGroup(groupId: "Group0", type: .Video, renditions: renditions)
        XCTAssertEqual(group.forcedRenditions, [])
    }
    
    func testDefaultRendition() {
        let renditions = [Rendition(language: Language(), name: "R1"),
                          Rendition(language: Language(), name: "R2", defaultRendition: true),
                          Rendition(language: Language(), name: "R3")]
        let group = RenditionGroup(groupId: "Group0", type: .Video, renditions: renditions)
        XCTAssertEqual(group.defaultRendition!, renditions[1])
    }
    
    func testForcedRendition() {
        let renditions = [Rendition(language: Language(), name: "R1"),
                          Rendition(language: Language(), name: "R2", defaultRendition: true, forced: true),
                          Rendition(language: Language(), name: "R3", forced: true)]
        let group = RenditionGroup(groupId: "Group0", type: .Video, renditions: renditions)
        XCTAssertEqual(group.forcedRenditions, [renditions[1], renditions[2]])
    }
    
    static var allTests : [(String, (RenditionGroupTests) -> () throws -> Void)] {
        return [("testNoDefaultRendition", testNoDefaultRendition),
                ("testNoForcedRenditions", testNoForcedRenditions),
                ("testDefaultRendition", testDefaultRendition),
                ("testForcedRendition", testForcedRendition)
        ]
    }
}
