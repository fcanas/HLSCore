//
//  HLSCoreTests.swift
//  HLSCore
//
//  Created by Fabian Canas on 8/13/16.
//  Copyright © 2016 Fabian Canas. All rights reserved.
//

import XCTest
import Types

class RenditionGroupTests: XCTestCase {

    func testNoDefaultRendition() {
        let renditions = [Rendition(mediaType: .Audio,
                                    uri: nil,
                                    groupID: "Group",
                                    language: Language.en,
                                    associatedLanguage: nil,
                                    name: "R1"),
                          Rendition(mediaType: .Audio,
                                    uri: nil,
                                    groupID: "Group",
                                    language: Language.en,
                                    associatedLanguage: nil,
                                    name: "R2"),
                          Rendition(mediaType: .Audio,
                                    uri: nil,
                                    groupID: "Group",
                                    language: Language.en,
                                    associatedLanguage: nil,
                                    name: "R3")]
        let group = RenditionGroup(groupId: "Group0", type: .Video, renditions: renditions)
        XCTAssertNil(group.defaultRendition)
    }

    func testNoForcedRenditions() {
        let renditions = [Rendition(mediaType: .Audio,
                                    uri: nil,
                                    groupID: "Group",
                                    language: Language.en,
                                    associatedLanguage: nil,
                                    name: "R1"),
                          Rendition(mediaType: .Audio,
                                    uri: nil,
                                    groupID: "Group",
                                    language: Language.en,
                                    associatedLanguage: nil,
                                    name: "R2"),
                          Rendition(mediaType: .Audio,
                                    uri: nil,
                                    groupID: "Group",
                                    language: Language.en,
                                    associatedLanguage: nil,
                                    name: "R3")]
        let group = RenditionGroup(groupId: "Group0", type: .Video, renditions: renditions)
        XCTAssertEqual(group.forcedRenditions, [])
    }

    func testDefaultRendition() {
        let renditions = [Rendition(mediaType: .Audio,
                                    uri: nil,
                                    groupID: "Group",
                                    language: Language.en,
                                    associatedLanguage: nil,
                                    name: "R1"),
                          Rendition(mediaType: .Audio,
                                    uri: nil,
                                    groupID: "Group",
                                    language: Language.en,
                                    associatedLanguage: nil,
                                    name: "R2",
                                    defaultRendition: true),
                          Rendition(mediaType: .Audio,
                                    uri: nil,
                                    groupID: "Group",
                                    language: Language.en,
                                    associatedLanguage: nil,
                                    name: "R3")]
        let group = RenditionGroup(groupId: "Group0", type: .Video, renditions: renditions)
        XCTAssertEqual(group.defaultRendition!, renditions[1])
    }

    func testForcedRendition() {
        let renditions = [Rendition(mediaType: .Audio,
                                    uri: nil,
                                    groupID: "Group",
                                    language: Language.en,
                                    associatedLanguage: nil,
                                    name: "R1"),
                          Rendition(mediaType: .Audio,
                                    uri: nil,
                                    groupID: "Group",
                                    language: Language.en,
                                    associatedLanguage: nil,
                                    name: "R2",
                                    defaultRendition: true,
                                    forced: true),
                          Rendition(mediaType: .Audio,
                                    uri: nil,
                                    groupID: "Group",
                                    language: Language.en,
                                    associatedLanguage: nil,
                                    name: "R3",
                                    forced: true)]
        let group = RenditionGroup(groupId: "Group0", type: .Video, renditions: renditions)
        XCTAssertEqual(group.forcedRenditions, [renditions[1], renditions[2]])
    }

    static var allTests: [(String, (RenditionGroupTests) -> () throws -> Void)] {
        return [("testNoDefaultRendition", testNoDefaultRendition),
                ("testNoForcedRenditions", testNoForcedRenditions),
                ("testDefaultRendition", testDefaultRendition),
                ("testForcedRendition", testForcedRendition)
        ]
    }
}

class StreamInfoTests: XCTestCase {

    func testSorting() {
        let a = StreamInfo(bandwidth: 1,
                           averageBandwidth: nil,
                           codecs: [Codec(rawValue: "h.264")],
                           resolution: Resolution(width: 3840, height: 2160),
                           frameRate: 60,
                           uri: URL(string:"/")!)
        let b = StreamInfo(bandwidth: 2,
                           averageBandwidth: nil,
                           codecs: [Codec(rawValue: "h.264")],
                           resolution: Resolution(width: 1920, height: 1080),
                           frameRate: 24,
                           uri: URL(string:"/")!)
        let c = StreamInfo(bandwidth: 30,
                           averageBandwidth: nil,
                           codecs: [Codec(rawValue: "h.264")],
                           resolution: Resolution(width: 1280, height: 720),
                           frameRate: 30,
                           uri: URL(string:"/")!)

        let bandwidth = [a,b,c].sorted(by: { $0.bandwidth < $1.bandwidth })
        XCTAssertEqual(bandwidth, [a, b, c])

        let framerate = [a,b,c].sorted(by: { $0.frameRate! < $1.frameRate! })
        XCTAssertEqual(framerate, [b, c, a])

        let height = [a,b,c].sorted(by: { $0.resolution!.height < $1.resolution!.height })
        XCTAssertEqual(height, [c, b, a])
    }
}

class BitrateTests: XCTestCase {
    func testBitrateEquatable() {
        for _ in 1...100 {
            let randomValue = UInt64(UInt.random(in: UInt.min...UInt.max))
            XCTAssertEqual(Bitrate(randomValue), Bitrate(randomValue))
        }
    }

    func testBitrateComparable() {
        for _ in 1...100 {
            let randomValueA = UInt64(UInt.random(in: UInt.min...UInt.max))
            let randomValueB = UInt64(UInt.random(in: UInt.min...UInt.max))

            XCTAssertEqual(Bitrate(randomValueA) > Bitrate(randomValueB),  randomValueA > randomValueB)
            XCTAssertEqual(Bitrate(randomValueA) < Bitrate(randomValueB),  randomValueA < randomValueB)
            XCTAssertEqual(Bitrate(randomValueA) <= Bitrate(randomValueB), randomValueA <= randomValueB)
            XCTAssertEqual(Bitrate(randomValueA) >= Bitrate(randomValueB), randomValueA >= randomValueB)
        }
    }

}
