//
//  TypeParsers.swift
//  HLSCore
//
//  Created by Fabian Canas on 9/5/16.
//  Copyright © 2016 Fabian Canas. All rights reserved.
//

import Foundation
import Types
import FFCParserCombinator

/// Raw Type Parsers

struct TypeParser {
    
    static let url = { URL(string: $0) } <^!> ({ String($0) } <^> CharacterSet.urlAllowed.parser().many1)

    static let hex = BasicParser.hexPrefix *> ({ characters in HexadecimalSequence(string: String(characters))! } <^> BasicParser.hexDigit.many1)

    static let float = { Double($0)! } <^> BasicParser.floatingPointString

    static let signedFloat = ({ SignedFloat($0)! } <^> BasicParser.negation.optional.followed(by: BasicParser.floatingPointString) { (neg, num) -> String in
        (neg ?? "") + num
        })

    static let quoteString = { QuotedString($0) } <^> BasicParser.quote *> CharacterSet.forQuotedString.parser().many <* BasicParser.quote

    static let enumString = EnumeratedString.init <^> CharacterSet.forEnumeratedString.parser().many1

    static let resolution = Resolution.init <^> UInt.parser <* BasicParser.x <&> UInt.parser

    static let date = dateFromString <^> ( { String($0) } <^> CharacterSet.iso8601.parser().many1 )

    static let byteRange = { return ($0.1 ?? 0)...(($0.1 ?? 0) + $0.0)  } <^> (UInt.parser <&> (character { $0 == "@" } *> UInt.parser ).optional)
}

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

