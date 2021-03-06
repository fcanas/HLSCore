//
//  PlaylistParsingTests.swift
//  HLSCore
//
//  Created by Fabian Canas on 10/22/16.
//  Copyright © 2016 Fabian Canas. All rights reserved.
//

import XCTest
import Types
import Parsing

class ParsingTests: XCTestCase {
    func testMediaPlaylist() {

        let inputPlaylist =
            "#EXTM3U" + "\n" +
                "#EXT-X-PLAYLIST-TYPE:VOD" + "\n" +
                "#EXT-X-TARGETDURATION:3" + "\n" +
                "#EXT-X-VERSION:3" + "\n" +
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
                "s6.ts" + "\n" +
                "#EXT-X-ENDLIST" + "\n"

        let urlString = "http://example.com/test/playlist.m3u8"
        let url = URL(string: urlString)!

        let s1URL = URL(string: "http://example.com/test/s1.ts")!
        let s2URL = URL(string: "s2.ts", relativeTo: url)!
        let s3URL = URL(string: "http://example.com/s3.ts")!
        let s4URL = URL(string: "http://example.com/test/alt/s4.ts")!
        let s5URL = URL(string: "s5.ts", relativeTo: url)!
        let s6URL = URL(string: "s6.ts", relativeTo: url)!

        let segments = [MediaSegment(uri: s1URL, duration: 3.1),
                        MediaSegment(uri: s2URL, duration: 3.0),
                        MediaSegment(uri: s3URL, duration: 3.2),
                        MediaSegment(uri: s4URL, duration: 2.9)]

        let unencryptedSegments =  [MediaSegment(uri: s5URL, duration: 3.0),
                                    MediaSegment(uri: s6URL, duration: 3.2)]
        let key = DecryptionKey(method: .AES128(URL(string: "ex.key")!))
        let encryptedSegments = setDecryptionKey(key, forSegments: unencryptedSegments)

        let playlist: MediaPlaylist = MediaPlaylist(type: .VOD, version: 3, uri: url, targetDuration: 3, closed: true, start: nil, segments: segments + encryptedSegments, independentSegments: false, mediaSequence: 0)

        let parsedPlaylist = parseMediaPlaylist(string: inputPlaylist, atURL: url)

        XCTAssertEqual(playlist, parsedPlaylist)
    }

    func testMasterPlaylistLogRemainder() {
        var inputPlaylist: String
        inputPlaylist = "#EXTM3U" + "\n"

        let urlString = "http://example.com/test/playlist.m3u8"
        let url = URL(string: urlString)!

        let error = FakeOutputStream()
        let info = FakeOutputStream()
        let logger = HLSLogging.Default(thresholdLevel: .error, errorOut: error, infoOut: info)

        _ = parseMasterPlaylist(string: inputPlaylist, atURL: url, logger: logger)

        XCTAssertEqual(error.logs, ["NO REMAINDER"])
        XCTAssertEqual(info.logs, [])

        inputPlaylist += "XYZ"
        error.logs = []

        _ = parseMasterPlaylist(string: inputPlaylist, atURL: url, logger: logger)

        XCTAssertEqual(error.logs, [])
        XCTAssertEqual(info.logs, ["REMAINDER:\nXYZ"])
    }

    func testMediaPlaylistLogRemainder() {
        var inputPlaylist: String
        inputPlaylist = "#EXTM3U" + "\n"

        let urlString = "http://example.com/test/playlist.m3u8"
        let url = URL(string: urlString)!

        let error = FakeOutputStream()
        let info = FakeOutputStream()
        let logger = HLSLogging.Default(thresholdLevel: .error, errorOut: error, infoOut: info)

        _ = parseMediaPlaylist(string: inputPlaylist, atURL: url, logger: logger)

        XCTAssertEqual(error.logs, ["NO REMAINDER"])
        XCTAssertEqual(info.logs, [])

        inputPlaylist += "XYZ"
        error.logs = []

        _ = parseMediaPlaylist(string: inputPlaylist, atURL: url, logger: logger)

        XCTAssertEqual(error.logs, [])
        XCTAssertEqual(info.logs, ["REMAINDER:\nXYZ"])
    }

    static var allTests: [(String, (ParsingTests) -> () throws -> Void)] {
        return [
            ("testMediaPlaylist", testMediaPlaylist)
        ]
    }
}
