
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
