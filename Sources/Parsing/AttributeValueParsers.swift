//
//  AttributeValueTypes.swift
//  HLSCore
//
//  Created by Fabian Canas on 9/4/16.
//
//

import Foundation
import Types

let int = { characters in UInt(String(characters))! } <^> digit.many1

let hexSequence = hexPrefix *> ({ characters in HexadecimalSequence(string: String(characters)) } <^> hexDigit.many)

let decimalFloatingPoint = { Double($0)! } <^> floatingPointString

let signedDecimalFloatingPoint = { Double($0)! } <^> negation.optional.followed(by: floatingPointString) { (neg, num) -> String in
    (neg ?? "") + num
}

let quotedString = { String($0) } <^> quote *> character(in: CharacterSet.forQuotedString ).many <* quote

let enumeratedString = { String($0) } <^> character(in: CharacterSet.forEnumeratedString).many1

let decimalResolution = Resolution.init <^> int <* x <&> int
