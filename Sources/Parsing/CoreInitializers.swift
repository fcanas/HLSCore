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

extension StartIndicator {

    static private let timeOffsetKey = "TIME-OFFSET"
    static private let preciseKey = "PRECISE"

    init?(attributes :AttributeList) {
        
        var timeOffset :TimeInterval?
        var precise :Bool?
        
        for attribute in attributes {
            switch attribute {
            case let (StartIndicator.timeOffsetKey, .decimalFloatingPoint(time)):
                timeOffset = time
            case let (StartIndicator.preciseKey, .enumeratedString(p)):
                assert(p.value == "YES" || p.value == "NO", "PRECISE attribute in EXT-X-START must be YES or NO")
                precise = p.value == "YES" ? true : false;
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
        
        var methodVar :EncryptionMethod? = nil
        var uriVar :URL? = nil
        var initializationVectorVar :(UInt64, UInt64)? = nil
        var keyFormatVar :String = IdentityDecryptionKeyFormat
        var keyFormatVersionsVar :[Int]? = nil
        
        for attribute in attributes {
            switch attribute {
            case let (DecryptionKey.methodKey, .enumeratedString(m)):
                guard let m = EncryptionMethod(rawValue: m.value) else {
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
                initializationVectorVar = (UInt64(h.value), UInt64(h.value))
            case let (DecryptionKey.keyFormatKey, .quotedString(s)):
                keyFormatVar = s
            case let (DecryptionKey.keyFormatVersionsKey, .quotedString(s)):
                keyFormatVersionsVar = s.components(separatedBy: "/").flatMap({ (string) -> Int? in
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
        
        self.init(method: method, uri: u, initializationVector: initializationVectorVar, keyFormat: keyFormatVar, keyFormatVersions: keyFormatVersionsVar)
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
    
    init?(attributes: AttributeList, uri :URL) {
        
        var bandwidthVar :Bitrate? = nil
        var averageBandwidthVar :Bitrate? = nil
        var codecsVar :[Codec] = []
        var resolutionVar :Resolution? = nil
        var framerateVar :Double? = nil
        
        for attribute in attributes {
            switch attribute {
            case let (AttributeKey.Bandwidth, .decimalInteger(i)):
                bandwidthVar = Bitrate(UIntMax(i))
            case let (AttributeKey.AverageBandwidth, .decimalInteger(i)):
                averageBandwidthVar = Bitrate(UIntMax(i))
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
        
        self.init(bandwidth: b, averageBandwidth: averageBandwidthVar, codecs: codecsVar, resolution: resolutionVar, frameRate: framerateVar, uri: uri)
    }
}

extension MediaSegment {
    
    init?(duration: AttributeValue, title: String?, range: CountableClosedRange<UInt>?, uri: URL?) {
        
        var durationVar :TimeInterval? = nil
        
        switch duration {
        case let .decimalFloatingPoint(boundDuration):
            durationVar = boundDuration
            break
        case let .decimalInteger(boundDuration):
            durationVar = TimeInterval(boundDuration)
            break
        default:
            break
        }
        
        guard let duration :TimeInterval = durationVar, let uri = uri else {
            return nil
        }
        
        // TODO : Our string parser will currently return a zero-length string 
        // when nothing is found, even for an optional string. If that's fixed,
        // this sanitization should be unnecessary.
        let sanitizedTitle :String?
        if title == "" {
            sanitizedTitle = nil
        } else {
            sanitizedTitle = title
        }
        
        self.init(uri: uri, duration: duration, title: sanitizedTitle, byteRange: range)
    }
    
}
