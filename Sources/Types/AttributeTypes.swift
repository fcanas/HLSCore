//
//  AttributeTypes.swift
//  HLSCore
//
//  Created by Fabian Canas on 9/4/16.
//  Copyright © 2016 Fabian Canas. All rights reserved.
//

import Foundation

public struct Resolution: Equatable, CustomStringConvertible {
    public let width: UInt
    public let height: UInt
    public init(width: UInt, height: UInt) {
        self.width = width
        self.height = height
    }

    public var description: String {
        return "\(width)x\(height)"
    }
}

public struct HexadecimalSequence: Equatable, CustomStringConvertible {
    public let value: UInt
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

    public var description: String {
        return "0x" + String(value, radix: 16, uppercase: true)
    }
}

public struct SignedFloat: Equatable, CustomStringConvertible, RawRepresentable {
    public let rawValue: Double
    public init(rawValue: Double) {
        self.rawValue = rawValue
    }

    public init?(_ string: String) {
        guard let v = Double(string) else {
            return nil
        }
        self.init(rawValue: v)
    }

    public var description: String {
        return rawValue.description
    }
}
