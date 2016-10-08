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

let date = dateFromString <^> ( { String($0) } <^> character(in: CharacterSet.iso8601).many1 )

@available(OSX 10.12, *) private let dateFormatter = ISO8601DateFormatter()

private let legacyFormatter :DateFormatter = {
    let f = DateFormatter()
    f.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
    return f
}()

private func dateFromString(_ string: String) -> Date? {
    if #available(OSX 10.12, *) {
        return dateFormatter.date(from: string)
    }
    
    return legacyFormatter.date(from: string)
}

