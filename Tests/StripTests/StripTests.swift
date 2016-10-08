import Foundation
import XCTest
@testable import Strip

class URLExtensionTests: XCTestCase {
    
    func testDetectSegment() {
        let segment = URL(string: "http://example.com/hls/stream/segment01.ts")
        let query = URL(string: "http://example.com/hls/stream/segment01.ts?q=thing")
        let fragment = URL(string: "http://example.com/hls/stream/segment01.ts#fragment")
        
        XCTAssertEqual(segment?.type, .Media)
        XCTAssertEqual(query?.type, .Media)
        XCTAssertEqual(fragment?.type, .Media)
    }
    
    func testDetectPlaylist() {
        let segment = URL(string: "http://example.com/hls/stream/segment01.m3u8")
        let query = URL(string: "http://example.com/hls/stream/segment01.m3u8?q=thing")
        let fragment = URL(string: "http://example.com/hls/stream/segment01.m3u8#fragment")
        
        XCTAssertEqual(segment?.type, .Playlist)
        XCTAssertEqual(query?.type, .Playlist)
        XCTAssertEqual(fragment?.type, .Playlist)
    }
    
    func testIgnoreNonHLSTypes() {
        let nonSegment = URL(string: "http://example.com/hls/stream/segment01.mp3")
        let query = URL(string: "http://example.com/hls/stream/segment01.aac?q=thing")
        let fragment = URL(string: "http://example.com/hls/stream/segment01.tts#fragment")
        
        XCTAssertEqual(nonSegment?.type, .Media)
        XCTAssertEqual(query?.type, .Media)
        XCTAssertEqual(fragment?.type, .Media)
    }
}

class HLSURLExtractionTests: XCTestCase {
    
    func testBasicPlaylist() {
        
        let playlistURL = Bundle(for: HLSURLExtractionTests.self).url(forResource: "playlist", withExtension: "m3u8")!
        let playlistString = try! String(contentsOf: playlistURL)
        
        let resources = resourceURLs(playlistString as NSString, manifestURL: URL(string:"http://www.example.com/directory/playlist.m3u8")!)
        
        print(resources)
        
        XCTAssertEqual(resources, [URL(string:"http://www.example.com/directory/s1.ts")!,
                                   URL(string:"http://www.example.com/directory/s2.ts")!,
                                   URL(string:"http://www.example.com/s3.ts")!,
                                   URL(string:"http://www.example.com/directory/alt/s4.ts")!,
                                   // TODO : Assert for the presence of http://www.example.com/directory/ex.key
                                   URL(string:"http://www.example.com/directory/s5.ts")!,
                                   URL(string:"http://www.example.com/directory/s6.ts")!,])
    }
    
}
