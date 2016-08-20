//
//  SerializationTests.swift
//  HLSCore
//
//  Created by Fabian Canas on 8/14/16.
//
//

import XCTest
// Here we test public behavior. We shouldn't import the module as testable
// because visibility is part of our contract.
import HLSCore

class SerializationTests: XCTestCase {
    func testBasicPlaylist() {
        let urlString = "http://example.com/test/playlist.m3u8"
        
        let s1URL = URL(string: "http://example.com/test/s1.ts")!
        let s2URL = URL(string: "http://example.com/test/s2.ts")!
        let s3URL = URL(string: "http://example.com/test/s3.ts")!
        let s4URL = URL(string: "http://example.com/test/s4.ts")!
        
        let segments = [MediaSegment(uri: s1URL, duration: 3.1),
                        MediaSegment(uri: s2URL, duration: 3.0),
                        MediaSegment(uri: s3URL, duration: 3.2),
                        MediaSegment(uri: s4URL, duration: 2.9)]
        
        let playlist :MediaPlaylist = MediaPlaylist(type: .VOD, version: 3, uri: URL(string: urlString)!, targetDuration: 12, closed: true, start: nil, segments: segments)
        
        let stringResource = MediaPlaylistSerlializer().serialize(playlist)
        
        XCTAssertEqual(stringResource.uri.absoluteString, urlString)
        
        let expectedPlaylist =
            "#EXTM3U" + "\n" +
                "#EXT-TARGET-DURATION:12" + "\n" +
                "#EXT-X-VERSION:3" + "\n" +
                "#EXT-X-PLAYLIST-TYPE:VOD" + "\n" +
                "#EXTINF:3.1" + "\n" +
                "s1.ts" + "\n" +
                "#EXTINF:3.0" + "\n" +
                "s2.ts" + "\n" +
                "#EXTINF:3.2" + "\n" +
                "s3.ts" + "\n" +
                "#EXTINF:2.9" + "\n" +
                "s4.ts" + "\n"
        
        AssertMatchMultilineString(stringResource.value!, expectedPlaylist, separator: "\n")
        
    }
    
    static var allTests : [(String, (SerializationTests) -> () throws -> Void)] {
        return [
            ("testBasicPlaylist", testBasicPlaylist),
        ]
    }
}
