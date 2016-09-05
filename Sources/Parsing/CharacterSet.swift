//
//  CharacterSet.swift
//  HLSCore
//
//  Created by Fabian Canas on 9/4/16.
//
//

import Foundation

extension CharacterSet {
    
    static let hexidecimalDigits = CharacterSet.decimalDigits.union(CharacterSet(charactersIn: "A"..."F"))
    
    static let forQuotedString = CharacterSet(charactersIn: "\r\n\"").inverted
    
    static let forEnumeratedString = CharacterSet(charactersIn: ",\"").union(CharacterSet.whitespacesAndNewlines).inverted
}
