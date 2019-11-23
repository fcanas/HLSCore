//
//  AttributeList.swift
//  HLSCore
//
//  Created by Fabian Canas on 9/5/16.
//  Copyright © 2016 Fabian Canas. All rights reserved.
//

import Foundation
import ParserCombinator

// All comments in this file represent section 4.2 of the HTTP Live Streaming
// RFC in order, in its entirety.
// Accessed May 5, 2018

/// [4.2](https://tools.ietf.org/html/rfc8216#section-4.2).  Attribute Lists

/**
 Certain tags have values that are attribute-lists.  An attribute-list
 is a comma-separated list of attribute/value pairs with no
 whitespace.
 */

typealias AttributeList = [AttributeName: AttributeValue]

typealias AttributePair = (AttributeName, AttributeValue)

let attributeList = builtAttributeList
                <^> attribute.followed(by: ( "," *> attribute ).many,
                                       combine: { (single, list) -> [AttributePair] in
                                                    [single] + list
                                                })

func builtAttributeList(attributes: [(AttributeName, AttributeValue)]) -> AttributeList {
    return attributes.reduce(AttributeList(), { (attributeList, keyValue) -> AttributeList in
        var newAttributeList = attributeList
        newAttributeList[keyValue.0] = keyValue.1
        return newAttributeList
    })
}

/**
 An attribute/value pair has the following syntax:

 AttributeName=AttributeValue
 */

let attribute = attributeName <* "=" <&> attributeValue

/**
 [4.2](https://tools.ietf.org/html/rfc8216#section-4.2) Continued

 An AttributeName is an unquoted string containing characters from the
 set [A..Z], [0..9] and '-'.  Therefore, AttributeNames contain only
 uppercase letters, not lowercase.  There MUST NOT be any whitespace
 between the AttributeName and the '=' character, nor between the '='
 character and the AttributeValue.
 */

typealias AttributeName = String

extension CharacterSet {
    static let forAttributeName = CharacterSet(charactersIn: "A"..."Z")
                                              .union(CharacterSet(charactersIn: "0"..."9"))
                                              .union(CharacterSet(charactersIn: "-"))
}

let attributeName = { AttributeName($0) } <^> CharacterSet.forAttributeName.parser().many1

/**
 [4.2](https://tools.ietf.org/html/rfc8216#section-4.2)

 An AttributeValue is one of the following:

 *  decimal-integer: an unquoted string of characters from the set
 [0..9] expressing an integer in base-10 arithmetic in the range
 from 0 to 2^64-1 (18446744073709551615).  A decimal-integer may be
 from 1 to 20 characters long.

 *  hexadecimal-sequence: an unquoted string of characters from the
 set [0..9] and [A..F] that is prefixed with 0x or 0X.  The maximum
 length of a hexadecimal-sequence depends on its AttributeNames.

 *  decimal-floating-point: an unquoted string of characters from the
 set [0..9] and '.' that expresses a non-negative floating-point
 number in decimal positional notation.

 *  signed-decimal-floating-point: an unquoted string of characters
 from the set [0..9], '-', and '.' that expresses a signed
 floating-point number in decimal positional notation.

 *  quoted-string: a string of characters within a pair of double
 quotes (0x22).  The following characters MUST NOT appear in a
 quoted-string: line feed (0xA), carriage return (0xD), or double
 quote (0x22).  Quoted-string AttributeValues SHOULD be constructed
 so that byte-wise comparison is sufficient to test two quoted-
 string AttributeValues for equality.  Note that this implies case-
 sensitive comparison.

 *  enumerated-string: an unquoted character string from a set that is
 explicitly defined by the AttributeName.  An enumerated-string
 will never contain double quotes ("), commas (,), or whitespace.

 *  decimal-resolution: two decimal-integers separated by the "x"
 character.  The first integer is a horizontal pixel dimension
 (width); the second is a vertical pixel dimension (height).
 */

let attributeValue = hexSequence
                 <|> decimalFloatingPoint
                 <|> signedDecimalFloatingPoint
                 <|> quotedString
                 <|> decimalResolution
                 <|> decimalInteger
                 <|> enumeratedString

/**
 The type of the AttributeValue for a given AttributeName is specified
 by the attribute definition.

 A given AttributeName MUST NOT appear more than once in a given
 attribute-list.  Clients SHOULD refuse to parse such Playlists.
 */
