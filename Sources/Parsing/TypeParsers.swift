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

struct TypeParser {
    
    static let url = { URL(string: $0) } <^!> ({ String($0) } <^> character(in: CharacterSet.urlAllowed).many1)

    static let hex = BasicParser.hexPrefix *> ({ characters in HexadecimalSequence(string: String(characters))! } <^> BasicParser.hexDigit.many1)

    static let float = { Double($0)! } <^> BasicParser.floatingPointString

    static let signedFloat = ({ SignedFloat($0)! } <^> BasicParser.negation.optional.followed(by: BasicParser.floatingPointString) { (neg, num) -> String in
        (neg ?? "") + num
        })

    static let quoteString = { QuotedString($0) } <^> BasicParser.quote *> character(in: CharacterSet.forQuotedString ).many <* BasicParser.quote

    static let enumString = EnumeratedString.init <^> character(in: CharacterSet.forEnumeratedString).many1

    static let resolution = Resolution.init <^> BasicParser.int <* BasicParser.x <&> BasicParser.int

    static let date = dateFromString <^> ( { String($0) } <^> character(in: CharacterSet.iso8601).many1 )

    static let byteRange = BasicParser.int <&> (character { $0 == "@" } *> BasicParser.int ).optional
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

