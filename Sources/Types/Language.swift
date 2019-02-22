//
//  Language.swift
//  HLSCore
//
//  Created by Fabian Canas on 8/27/16.
//  Copyright © 2016 Fabian Canas. All rights reserved.
//

public struct Language: Equatable {

    let value: String

    public init(_ string: String) {
        value = string
    }
}

public extension Language {
    static let de = Language("de")
    static let en = Language("en")
    static let es = Language("es")
    static let fr = Language("fr")
    static let ja = Language("ja")
    static let zh = Language("zh")
}
