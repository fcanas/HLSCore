//
//  AttributeTypes.swift
//  HLSCore
//
//  Created by Fabian Canas on 9/4/16.
//  Copyright © 2016 Fabian Canas. All rights reserved.
//

import Foundation

public struct Resolution : Equatable {
    public let width :UInt
    public let height :UInt
    public init(width: UInt, height: UInt) {
        self.width = width
        self.height = height
    }
    
    public static func ==(lhs: Resolution, rhs: Resolution) -> Bool {
        return lhs.width == rhs.width &&
            lhs.height == rhs.height
    }
}

public struct HexadecimalSequence : Equatable {
    let value :UInt
    /**
     * param string - a hex string, upper or lower case, without preceeding 0x
     */
    public init?(string: String) {
        guard let v = UInt(string, radix: 16) else {
            return nil
        }
        value = v
    }
    
    public init(value v: UInt) {
        value = v
    }
    
    public static func ==(lhs: HexadecimalSequence, rhs: HexadecimalSequence) -> Bool {
        return lhs.value == rhs.value
    }
    
    var stringValue :String {
        get {
            return "0x" + String(value, radix:16, uppercase: true)
        }
    }
}

public struct SignedFloat {
    public let value :Double
    public init(_ double: Double) {
        value = double
    }
    
    public init?(_ string: String) {
        guard let v = Double(string) else {
            return nil
        }
        self.init(v)
    }
}
