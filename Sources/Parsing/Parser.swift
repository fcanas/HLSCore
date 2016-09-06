//
//  Parser.swift
//  HLSCore
//
//  Created by Fabian Canas on 9/3/16.
//  Copyright © 2016 Fabian Canas. All rights reserved.
//

import Foundation

typealias Tokenizer<T> = (String) -> (token: T, remainder: String)

enum Tag {
    case Version(VersionX)
    case Info(Double,String)
    case Byterange(count: Int, offset: Int)
    case Discontinuity
    case Key(KeyAttributes)
}

struct KeyAttributes {
    enum Method {
        case None
        case AES128
        case SampleAES
    }
    
    let method :Method
    let uri :URL
    let iv :(low: Int, high: Int)?
}

enum VersionX {
    case One
    case Two
}

let nextTag :Tokenizer<Tag?> = { (input) in
    if input.characters.first != "#" {
        return (nil, input)
    }
    return (token: .Version(.One), "")
}
