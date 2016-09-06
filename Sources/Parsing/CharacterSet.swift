//
//  CharacterSet.swift
//  HLSCore
//
//  Created by Fabian Canas on 9/4/16.
//  Copyright © 2016 Fabian Canas. All rights reserved.
//

import Foundation

extension CharacterSet {
    
    static let hexidecimalDigits = CharacterSet.decimalDigits.union(CharacterSet(charactersIn: "A"..."F"))
    
    static let forQuotedString = CharacterSet(charactersIn: "\r\n\"").inverted
    
    static let forEnumeratedString = CharacterSet(charactersIn: ",\"").union(CharacterSet.whitespacesAndNewlines).inverted
    
    static let forAttributeName = CharacterSet(charactersIn: "A"..."Z").union(CharacterSet(charactersIn: "0"..."9")).union(CharacterSet(charactersIn: "-"))
}
