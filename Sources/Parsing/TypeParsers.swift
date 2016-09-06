//
//  TypeParsers.swift
//  HLSCore
//
//  Created by Fabian Canas on 9/5/16.
//  Copyright © 2016 Fabian Canas. All rights reserved.
//

import Foundation
import Types

/// Raw Type Parsers

let hex = hexPrefix *> ({ characters in HexadecimalSequence(string: String(characters))! } <^> hexDigit.many1)

let float = { Double($0)! } <^> floatingPointString

let signedFloat = ({ SignedFloat($0)! } <^> negation.optional.followed(by: floatingPointString) { (neg, num) -> String in
    (neg ?? "") + num
    })

let quoteString = { QuotedString($0) } <^> quote *> character(in: CharacterSet.forQuotedString ).many <* quote

let enumString = EnumeratedString.init <^> character(in: CharacterSet.forEnumeratedString).many1

let resolution = Resolution.init <^> int <* x <&> int
