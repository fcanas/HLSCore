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

/// Parsers

let attributeName = { AttributeName($0) } <^> character(in: CharacterSet.forAttributeName).many1

let attributeParameter = decimalInteger <|> hexSequence <|> decimalFloatingPoint <|> signedDecimalFloatingPoint <|> quotedString <|> enumeratedString <|> decimalResolution

let attributeList = ( attributeName <* string("=") *> attributeParameter ).many1
