//
//  CoreInitializers.swift
//  HLSCore
//
//  Created by Fabian Canas on 9/13/16.
//  Copyright © 2016 Fabian Canas. All rights reserved.
//

import Foundation
import Types

// Initialize core HLS components built from parser results

/// EnumeratedString Extension for StartIndicator
fileprivate extension EnumeratedString {
    static let yes = EnumeratedString("YES")
    static let no = EnumeratedString("NO")
}

extension StartIndicator {

    static private let timeOffsetKey = "TIME-OFFSET"
    static private let preciseKey = "PRECISE"

    init?(attributes: AttributeList) {

        var timeOffset: TimeInterval?
        var precise: Bool?

        for attribute in attributes {
            switch attribute {
            case let (StartIndicator.timeOffsetKey, .decimalFloatingPoint(time)):
                timeOffset = time
            case let (StartIndicator.preciseKey, .enumeratedString(p)):
                switch p {
                case .yes:
                    precise = true
                case .no:
                    precise = false
                default:
                    assert(false, "PRECISE attribute in EXT-X-START must be YES or NO")
                    precise = false
                }
            default:
                return nil
            }
        }

        guard let offset = timeOffset else {
            return nil
        }

        if let precise = precise {
            self.init(at: offset, preciseStart: precise)
        } else {
            // Let initializer decide default value of non-required parameter
            self.init(at: offset)
        }
    }
}

extension DecryptionKey {

    static private let methodKey = "METHOD"
    static private let uriKey = "URI"
    static private let initializationVectorKey = "IV"
    static private let keyFormatKey = "KEYFORMAT"
    static private let keyFormatVersionsKey = "KEYFORMATVERSIONS"

    init?(attributes: AttributeList) {

        var methodVar: EncryptionMethod?
        var uriVar: URL?
        var initializationVectorVar: InitializationVector?
        var keyFormatVar: String = IdentityDecryptionKeyFormat
        var keyFormatVersionsVar: [Int]?

        for attribute in attributes {
            switch attribute {
            case let (DecryptionKey.methodKey, .enumeratedString(m)):
                guard let m = EncryptionMethod(rawValue: m.rawValue) else {
                    return nil
                }
                methodVar = m
            case let (DecryptionKey.uriKey, .quotedString(s)):
                guard let u = URL(string: s) else {
                    return nil
                }
                uriVar = u
            case let (DecryptionKey.initializationVectorKey, .hexadecimalSequence(h)):
                // TODO: Extend HexadecimalSequence to encode 128-bit numbers
                initializationVectorVar = InitializationVector(low: UInt64(h.value), high: UInt64(h.value))
            case let (DecryptionKey.keyFormatKey, .quotedString(s)):
                keyFormatVar = s
            case let (DecryptionKey.keyFormatVersionsKey, .quotedString(s)):
                keyFormatVersionsVar = s.components(separatedBy: "/").compactMap({ (string) -> Int? in
                    Int(string)
                })
            default:
                break
            }
        }

        guard let method = methodVar else {
            return nil
        }

        if method != .None && uriVar == nil {
            return nil
        }

        guard let u = uriVar else {
            return nil
        }

        self.init(method: method,
                  uri: u,
                  initializationVector: initializationVectorVar,
                  keyFormat: keyFormatVar,
                  keyFormatVersions: keyFormatVersionsVar)
    }
}

extension StreamInfo {

    fileprivate struct AttributeKey {
        static fileprivate let Bandwidth = "BANDWIDTH"
        static fileprivate let AverageBandwidth = "AVERAGE-BANDWIDTH"
        static fileprivate let Codecs = "CODECS"
        static fileprivate let Resolution = "RESOLUTION"
        static fileprivate let FrameRate = "FRAME-RATE"
        static fileprivate let Audio = "AUDIO"
        static fileprivate let Video = "VIDEO"
        static fileprivate let Subtitles = "SUBTITLES"
        static fileprivate let ClosedCaptions = "CLOSED-CAPTIONS"
    }

    init?(attributes: AttributeList, uri: URL) {

        var bandwidthVar: Bitrate?
        var averageBandwidthVar: Bitrate?
        var codecsVar: [Codec] = []
        var resolutionVar: Resolution?
        var framerateVar: Double?

        for attribute in attributes {
            switch attribute {
            case let (AttributeKey.Bandwidth, .decimalInteger(i)):
                bandwidthVar = Bitrate(UInt64(i))
            case let (AttributeKey.AverageBandwidth, .decimalInteger(i)):
                averageBandwidthVar = Bitrate(UInt64(i))
            case let (AttributeKey.Codecs, .quotedString(s)):
                codecsVar = s.components(separatedBy: ",").map { Codec(rawValue: $0) }
            case let (AttributeKey.Resolution, .decimalResolution(r)):
                resolutionVar = r
            case let (AttributeKey.FrameRate, .decimalFloatingPoint(f)):
                framerateVar = f
            default:
                break
            }
        }

        guard let b = bandwidthVar else {
            return nil
        }

        self.init(bandwidth: b,
                  averageBandwidth: averageBandwidthVar,
                  codecs: codecsVar,
                  resolution: resolutionVar,
                  frameRate: framerateVar,
                  uri: uri)
    }
}

extension MediaInitializationSection {

    fileprivate struct AttributeKey {
        static fileprivate let URI = "URI"
        static fileprivate let ByteRange = "BYTERANGE"
    }

    init?(attributes: AttributeList) {

        var urlVar: URL?
        var byteRangeVar: CountableClosedRange<UInt>?

        for attribute in attributes {
            switch attribute {
            case let (AttributeKey.URI, .quotedString(urlString)):
                urlVar = URL(string: urlString)
            case let (AttributeKey.ByteRange, .quotedString(byteRangeString)):
                let parseResults = TypeParser.byteRange.run(byteRangeString)
                guard let range = parseResults?.0 else {
                    return nil
                }
                byteRangeVar = range
            default:
                break
            }
        }

        guard let url = urlVar else {
            return nil
        }

        self.init(uri: url, byteRange: byteRangeVar)
    }

}

extension Rendition {

    fileprivate struct AttributeKey {
        static fileprivate let type = "TYPE"
        static fileprivate let uri = "URI"
        static fileprivate let groupID = "GROUP-ID"
        static fileprivate let language = "LANGUAGE"
        static fileprivate let associatedLanguage = "ASSOC-LANGUAGE"
        static fileprivate let name = "NAME"
        static fileprivate let `default` = "DEFAULT"
        static fileprivate let autoselect = "AUTOSELECT"
        static fileprivate let forced = "FORCED"
        static fileprivate let instreamID = "INSTREAM-ID"
        static fileprivate let characteristics = "CHARACTERISTICS"
    }

    init?(attributes: AttributeList) {

        var type: MediaType?
        var uri: URL?
        var groupID: String?
        var language: Language?
        var associatedLanguage: Language?
        var name: String?
        var defaultRendition = false
        var forced = false

        for attribute in attributes {
            switch attribute {
            case let (AttributeKey.type, .enumeratedString(typeString)):
                type = MediaType(rawValue: typeString.rawValue)
            case let (AttributeKey.uri, .quotedString(uriString)):
                uri = URL(string: uriString)
            case let (AttributeKey.groupID, .quotedString(renditionGroup)):
                groupID = renditionGroup
            case let (AttributeKey.language, .quotedString(languageString)):
                language = Language(languageString)
            case let (AttributeKey.associatedLanguage, .quotedString(associatedLanguageString)):
                associatedLanguage = Language(associatedLanguageString)
            case let (AttributeKey.name, .quotedString(nameString)):
                name = nameString
            case let (AttributeKey.default, .enumeratedString(boolString)):
                guard let isDefault = ["YES": true, "NO": false][boolString.rawValue] else {
                    return nil
                }
                defaultRendition = isDefault
            case let (AttributeKey.autoselect, .enumeratedString(boolString)):
                guard let isForced = ["YES": true, "NO": false][boolString.rawValue] else {
                    return nil
                }
                forced = isForced
            default:
                break
            }
        }

        guard let mediaType = type, let group = groupID, let renditionName = name else {
            return nil
        }

        self.init(mediaType: mediaType,
                  uri: uri,
                  groupID: group,
                  language: language,
                  associatedLanguage: associatedLanguage,
                  name: renditionName,
                  defaultRendition: defaultRendition,
                  forced: forced)

    }

}
