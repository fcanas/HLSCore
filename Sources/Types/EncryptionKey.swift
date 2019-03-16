//
//  EncryptionKey.swift
//  HLSCore
//
//  Created by Fabian Canas on 9/22/16.
//  Copyright © 2016 Fabian Canas. All rights reserved.
//

import Foundation

public enum EncryptionMethod: Equatable {
    case None
    case AES128(URL)
    case SampleAES(URL)
}

public let IdentityDecryptionKeyFormat = "identity"

public struct InitializationVector: Equatable {
    public let low: UInt64
    public let high: UInt64
    public init(low: UInt64, high: UInt64) {
        self.low = low
        self.high = high
    }
}

public struct DecryptionKey: Equatable {

    public let method: EncryptionMethod
    public let initializationVector: InitializationVector?
    public let keyFormat: String
    public let keyFormatVersions: [Int]?

    public init(method: EncryptionMethod,
                initializationVector: InitializationVector? = nil,
                keyFormat: String = IdentityDecryptionKeyFormat,
                keyFormatVersions: [Int]? = nil) {
        self.method = method
        self.initializationVector = initializationVector
        self.keyFormat = keyFormat
        self.keyFormatVersions = keyFormatVersions
    }

    private init() {
        self.method = .None
        self.keyFormat = IdentityDecryptionKeyFormat

        keyFormatVersions = nil
        initializationVector = nil
    }

    public static let None: DecryptionKey = DecryptionKey.init()

}

public func setDecryptionKey(_ key: DecryptionKey, forSegments segments: [MediaSegment]) -> [MediaSegment] {
    return segments.map {
        var segment = $0
        segment.decryptionKey = key
        return segment
    }
}
