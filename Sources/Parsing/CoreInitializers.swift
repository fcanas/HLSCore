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
