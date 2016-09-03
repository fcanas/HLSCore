//
//  Language.swift
//  HLSCore
//
//  Created by Fabian Canas on 8/27/16.
//  Copyright © 2016 Fabian Canas. All rights reserved.
//

public struct Language : Equatable {
    
    let value :String
    
    public init(_ string: String) {
        value = string
    }
    
    public static func ==(lhs :Language, rhs: Language) -> Bool {
        return lhs.value == rhs.value
    }
}

public extension Language {
    public static let de = Language("de")
    public static let en = Language("en")
    public static let es = Language("es")
    public static let fr = Language("fr")
    public static let ja = Language("ja")
    public static let zh = Language("zh")
}
