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

extension AttributeValue : CustomStringConvertible {
    var description: String {
        get {
            switch self {
            case let .decimalInteger(int):
                return int.description
            case let .hexadecimalSequence(hex):
                return hex.description
            case let .decimalFloatingPoint(float):
                return float.description
            case let .signedDecimalFloatingPoint(signedFloat):
                return signedFloat.description
            case let .quotedString(string):
                return string
            case let .enumeratedString(enumeratedString):
                return enumeratedString.description
            case let .decimalResolution(resolution):
                return resolution.description
            }
        }
    }

}

extension AttributeValue : Equatable {
    static func ==(lhs: AttributeValue, rhs: AttributeValue) -> Bool {
        
        switch (lhs, rhs) {
        case let (.decimalInteger(l), .decimalInteger(r)) where l == r:
            return true
        case let (.hexadecimalSequence(l), .hexadecimalSequence(r)) where l == r:
            return true
        case let (.decimalFloatingPoint(l), .decimalFloatingPoint(r)) where l == r:
            return true
        case let (.signedDecimalFloatingPoint(l), .signedDecimalFloatingPoint(r)) where l == r:
            return true
        case let (.quotedString(l), .quotedString(r)) where l == r:
            return true
        case let (.enumeratedString(l), .enumeratedString(r)) where l == r:
            return true
        case let (.decimalResolution(l), .decimalResolution(r)) where l == r:
            return true
        default:
            return false
        }
    }
}

typealias QuotedString = String

struct EnumeratedString : RawRepresentable, Equatable, CustomStringConvertible {
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
    
    var description: String {
        get {
            return rawValue
        }
    }
}

/// Attribute Value Parsers

let decimalInteger = AttributeValue.init <^> BasicParser.int

let hexSequence = AttributeValue.init <^> TypeParser.hex

let decimalFloatingPoint = AttributeValue.init <^> TypeParser.float

let signedDecimalFloatingPoint = AttributeValue.init <^> TypeParser.signedFloat

let quotedString = AttributeValue.init <^> TypeParser.quoteString

let enumeratedString = AttributeValue.init <^> TypeParser.enumString

let decimalResolution = AttributeValue.init <^> TypeParser.resolution
