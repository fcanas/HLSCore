import Foundation

struct HLSCore {

    var text = "Hello, World!"
}

protocol Resource {
    var uri :URL { get }
}

struct StartIndicator {
    let timeOffset :TimeInterval
    let preciseStart :Bool = false
}

protocol Playlist : Resource {
    var version :Int { get }
    var start :StartIndicator? { get }
}

/// Master Playlist

struct MasterPlaylist : Playlist {
    let version: Int
    let uri :URL
    
    let streams :[MediaPlaylist]
    let start :StartIndicator?
}

enum MediaType {
    case Audio
    case Video
    case Subtitles
    case ClosedCaptions
}

struct Language : Equatable {
    static func ==(lhs :Language, rhs: Language) -> Bool {
        return true
    }
}

/// EXT-X-MEDIA
struct Rendition {
    let language :Language
    let name :String
    
    init(language: Language, name: String, defaultRendition: Bool = false, forced: Bool = false) {
        self.language = language
        self.name = name
        self.defaultRendition = defaultRendition
        self.forced = forced
    }
    
    private let defaultRendition :Bool
    private let forced :Bool
}

extension Rendition : Equatable {
    static func ==(lhs: Rendition, rhs: Rendition) -> Bool {
        return lhs.language == rhs.language &&
               lhs.name == rhs.name
    }
}

struct RenditionGroup {
    let groupId :String
    let type :MediaType
    
    let renditions :[Rendition]
    
    init(groupId: String, type: MediaType, renditions: [Rendition]) {
        self.groupId = groupId
        self.type = type
        self.renditions = renditions
        
        defaultRendition = self.renditions.first { $0.defaultRendition }
        forcedRenditions = self.renditions.filter { $0.forced }
    }
    
    let defaultRendition :Rendition?
    
    let forcedRenditions :[Rendition]
}

/// Bits per second
struct Bitrate : Comparable {
    let value :UInt
    
    static func ==(lhs: Bitrate, rhs: Bitrate) -> Bool {
        return lhs.value == rhs.value
    }
    
    static func <(lhs: Bitrate, rhs: Bitrate) -> Bool {
        return lhs.value < rhs.value
    }
    
    func toUIntMax() -> UIntMax {
        return value.toUIntMax()
    }
    
    init(_ v: UIntMax) {
        value = UInt(v)
    }
}

/// RFC6381
struct Codec {
    // TODO
}

struct Resolution {
    let width :Int
    let height :Int
}

/// EXT-X-STREAM-INF
struct StreamInfo {
    /// Peak segment bitrate in bits per second
    let bandwidth :Bitrate
    let averageBandwidth :Bitrate
    let codecs :[Codec]
    let resolution :Resolution
    let frameRate :Double
    
    let uri :URL
}

struct MediaPlaylist : Playlist {
    
    enum PlaylistType {
        case VOD
        case Event
    }
    
    let type :PlaylistType?
    
    let version :Int
    var playlist :MasterPlaylist
    let uri :URL
    
    let targetDuration :TimeInterval
    
    /// Marks the presence of a `EXT-X-ENDLIST` tag
    let closed :Bool
    
    let start :StartIndicator?
}

/// Media

struct MediaSegment {
    var playlist :MediaPlaylist
    
    var resource :MediaResource
    var range :Range<Int>
    
    let duration :TimeInterval
    let title :String?
    
}

struct MediaResource : Resource {
    let uri :URL
}
