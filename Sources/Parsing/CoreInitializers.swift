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
            case let (StartIndicator.timeOffsetKey, .DecimalFloatingPoint(time)):
                timeOffset = time
            case let (StartIndicator.preciseKey, .EnumeratedString(p)):
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

extension MediaSegment {
    
    init?(duration: AttributeValue, title: String?, range: CountableClosedRange<UInt>?, uri: URL?) {
        
        var durationVar :TimeInterval? = nil
        
        switch duration {
        case let .DecimalFloatingPoint(boundDuration):
            durationVar = boundDuration
            break
        case let .DecimalInteger(boundDuration):
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
