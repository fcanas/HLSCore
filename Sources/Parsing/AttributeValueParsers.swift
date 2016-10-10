//
//  AttributeValueTypes.swift
//  HLSCore
//
//  Created by Fabian Canas on 9/4/16.
//  Copyright © 2016 Fabian Canas. All rights reserved.
//

import Foundation
import Types

/// Attributes in Attribute lists can take on a limited number of types.
enum AttributeValue {
    case decimalInteger(UInt)
    case hexadecimalSequence(HexadecimalSequence)
    case decimalFloatingPoint(Double)
    case signedDecimalFloatingPoint(SignedFloat)
    case quotedString(String)
    case enumeratedString(EnumeratedString)
    case decimalResolution(Resolution)
    
    init(_ int: UInt) {
        self = .decimalInteger(int)
    }
    
    init(_ hex: HexadecimalSequence) {
        self = .hexadecimalSequence(hex)
    }
    
    init(_ float: Double) {
        self = .decimalFloatingPoint(float)
    }
    
    init(_ signedFloat: SignedFloat) {
        self = .signedDecimalFloatingPoint(signedFloat)
    }
    
    init(_ quotedString: String) {
        self = .quotedString(quotedString)
    }
    
    init(_ enumeratedString: EnumeratedString) {
        self = .enumeratedString(enumeratedString)
    }
    
    init(_ decimalResolution: Resolution) {
        self = .decimalResolution(decimalResolution)
    }
    
}

typealias QuotedString = String

struct EnumeratedString : RawRepresentable, Equatable {
    let rawValue :String
    
    init(_ string: String) {
        rawValue = string
    }
    
    init(_ characters: [Character]) {
        rawValue = String(characters)
    }
    
    init(rawValue: String) {
        self.rawValue = rawValue
    }

    static func ==(lhs: EnumeratedString, rhs: EnumeratedString) -> Bool {
        return lhs.rawValue == rhs.rawValue
    }
}

/// Attribute Value Parsers

let decimalInteger = AttributeValue.init <^> int

let hexSequence = AttributeValue.init <^> hex

let decimalFloatingPoint = AttributeValue.init <^> float

let signedDecimalFloatingPoint = AttributeValue.init <^> signedFloat

let quotedString = AttributeValue.init <^> quoteString

let enumeratedString = AttributeValue.init <^> enumString

let decimalResolution = AttributeValue.init <^> resolution
