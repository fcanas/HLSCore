//
//  AttributeValueTypes.swift
//  HLSCore
//
//  Created by Fabian Canas on 9/4/16.
//  Copyright © 2016 Fabian Canas. All rights reserved.
//

import Foundation
import Types
import FFCParserCombinator

/// Attributes in Attribute lists can take on a limited number of types.
enum AttributeValue: Equatable {
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

extension AttributeValue: CustomStringConvertible {
    var description: String {
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

typealias QuotedString = String

struct EnumeratedString: RawRepresentable, Equatable, CustomStringConvertible {
    let rawValue: String

    init(_ string: String) {
        rawValue = string
    }

    init(_ characters: [Character]) {
        rawValue = String(characters)
    }

    init(rawValue: String) {
        self.rawValue = rawValue
    }

    var description: String {
        return rawValue
    }
}

/// Attribute Value Parsers

let decimalInteger = AttributeValue.init <^> UInt.parser

let hexSequence = AttributeValue.init <^> TypeParser.hex

let decimalFloatingPoint = AttributeValue.init <^> TypeParser.float

let signedDecimalFloatingPoint = AttributeValue.init <^> TypeParser.signedFloat

let quotedString = AttributeValue.init <^> TypeParser.quoteString

let enumeratedString = AttributeValue.init <^> TypeParser.enumString

let decimalResolution = AttributeValue.init <^> TypeParser.resolution
