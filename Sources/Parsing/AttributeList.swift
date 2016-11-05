//
//  AttributeList.swift
//  HLSCore
//
//  Created by Fabian Canas on 9/5/16.
//  Copyright © 2016 Fabian Canas. All rights reserved.
//

import Foundation
import Types

typealias AttributeName = String

typealias AttributeList = Dictionary<AttributeName, AttributeValue>

typealias AttributePair = (AttributeName, AttributeValue)

/// Parsers

let attributeName = { AttributeName($0) } <^> character(in: CharacterSet.forAttributeName).many1

let attributeParameter = hexSequence <|> decimalFloatingPoint <|> signedDecimalFloatingPoint <|> quotedString <|> decimalResolution <|> decimalInteger <|> enumeratedString



let attribute = attributeName <* string("=") <&> attributeParameter

func builtAttributeList(attributes :[(AttributeName, AttributeValue)]) -> AttributeList {
    return attributes.reduce(AttributeList(), { (a, kv) -> AttributeList in
        var r = a
        r[kv.0] = kv.1
        return r
    })
}

let attributeList = builtAttributeList <^> attribute.followed(by: ( string(",") *> attribute ).many, combine: { (single, list) -> [AttributePair] in
    [single] + list
})


