//
//  SerializationTests.swift
//  HLSCore
//
//  Created by Fabian Canas on 8/14/16.
//  Copyright © 2016 Fabian Canas. All rights reserved.
//

import XCTest
// Here we test public behavior. We shouldn't import the module as testable
// because visibility is part of our contract.
import Serialization
import Types

class SerializationTests: XCTestCase {
    func testBasicPlaylist() {
        let urlString = "http://example.com/test/playlist.m3u8"

        let s1URL = URL(string: "http://example.com/test/s1.ts")!
        let s2URL = URL(string: "s2.ts")!
        let s3URL = URL(string: "http://example.com/s3.ts")!
        let s4URL = URL(string: "http://example.com/test/alt/s4.ts")!
        let s5URL = URL(string: "s5.ts")!
        let s6URL = URL(string: "s6.ts")!

        let segments = [MediaSegment(uri: s1URL, duration: 3.1),
                        MediaSegment(uri: s2URL, duration: 3.0),
                        MediaSegment(uri: s3URL, duration: 3.2),
                        MediaSegment(uri: s4URL, duration: 2.9)]

        let unencryptedSegments =  [MediaSegment(uri: s5URL, duration: 3.0),
                                    MediaSegment(uri: s6URL, duration: 3.2)]
        let key = DecryptionKey(method: .AES128, uri: URL(string: "ex.key")!)
        let encryptedSegments = setDecryptionKey(key, forSegments: unencryptedSegments)

        let playlist: MediaPlaylist = MediaPlaylist(type: .VOD,
                                                    version: 3,
                                                    uri: URL(string: urlString)!,
                                                    targetDuration: 3,
                                                    closed: true,
                                                    start: nil,
                                                    segments: segments + encryptedSegments,
                                                    independentSegments: false,
                                                    mediaSequence: 0)

        let stringResource = MediaPlaylistSerializer().serialize(playlist)

        XCTAssertEqual(stringResource.uri.absoluteString, urlString)

        let expectedPlaylist =
                "#EXTM3U" + "\n" +
                "#EXT-X-TARGETDURATION:3" + "\n" +
                "#EXT-X-VERSION:3" + "\n" +
                "#EXT-X-PLAYLIST-TYPE:VOD" + "\n" +
                "#EXTINF:3.1," + "\n" +
                "s1.ts" + "\n" +
                "#EXTINF:3.0," + "\n" +
                "s2.ts" + "\n" +
                "#EXTINF:3.2," + "\n" +
                "../s3.ts" + "\n" +
                "#EXTINF:2.9," + "\n" +
                "alt/s4.ts" + "\n" +
                "#EXT-X-KEY:METHOD=AES-128,URI=\"ex.key\"" + "\n" +
                "#EXTINF:3.0," + "\n" +
                "s5.ts" + "\n" +
                "#EXTINF:3.2," + "\n" +
                "s6.ts" + "\n"

        AssertMatchMultilineString(stringResource.value!, expectedPlaylist, separator: "\n")
    }

    static var allTests: [(String, (SerializationTests) -> () throws -> Void)] {
        return [
            ("testBasicPlaylist", testBasicPlaylist)
        ]
    }
}
