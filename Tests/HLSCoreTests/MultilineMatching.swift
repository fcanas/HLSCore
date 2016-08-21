//
//  MultilineMatching.swift
//  HLSCore
//
//  Created by Fabian Canas on 8/14/16.
//  Copyright © 2016 Fabian Canas. All rights reserved.
//

import Foundation
import XCTest

func AssertMatchMultilineString( _ e1: @autoclosure () throws -> String, _ e2: @autoclosure () throws -> String, separator: String, file: StaticString = #file, line: UInt = #line) {
    
    do {
        let e1Components = try e1().components(separatedBy: separator)
        let e2Components = try e2().components(separatedBy: separator)
        
        let z = zip(e1Components, e2Components)
        
        var fileLine :Int = 0
        for (s1, s2) in z {
            fileLine += 1
            XCTAssertEqual(s1, s2, file: file, line: line)
        }
        
        XCTAssertEqual(e1Components.count, e2Components.count, "Expected \(e1Components.count) lines, but found \(e2Components.count) lines")
        
    } catch {
        XCTFail(file: file, line: line)
    }
    
}
