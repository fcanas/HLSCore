//
//  AttributeValueTypes.swift
//  HLSCore
//
//  Created by Fabian Canas on 9/4/16.
//  Copyright © 2016 Fabian Canas. All rights reserved.
//

import Foundation
import Types

enum AttributeValue {
    case DecimalInteger(UInt)
    case HexadecimalSequence(HexadecimalSequence)
    case DecimalFloatingPoint(Double)
    case SignedDecimalFloatingPoint(SignedFloat)
    case QuotedString(String)
    case EnumeratedString(EnumeratedString)
    case DecimalResolution(Resolution)
    
    init(_ int: UInt) {
        self = .DecimalInteger(int)
    }
    
    init(_ hex: HexadecimalSequence) {
        self = .HexadecimalSequence(hex)
    }
    
    init(_ float: Double) {
        self = .DecimalFloatingPoint(float)
    }
    
    init(_ signedFloat: SignedFloat) {
        self = .SignedDecimalFloatingPoint(signedFloat)
    }
    
    init(_ quotedString: String) {
        self = .QuotedString(quotedString)
    }
    
    init(_ enumeratedString: EnumeratedString) {
        self = .EnumeratedString(enumeratedString)
    }
    
    init(_ decimalResolution: Resolution) {
        self = .DecimalResolution(decimalResolution)
    }
    
}

typealias QuotedString = String

struct EnumeratedString {
    let value :String
    
    init(_ string: String) {
        value = string
    }
    
    init(_ characters: [Character]) {
        value = String(characters)
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
