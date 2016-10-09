//
//  EncryptionKey.swift
//  HLSCore
//
//  Created by Fabian Canas on 9/22/16.
//  Copyright © 2016 Fabian Canas. All rights reserved.
//

import Foundation

public enum EncryptionMethod :String {
    case None = "NONE"
    case AES128 = "AES-128"
    case SampleAES = "SAMPLE-AES"
}

public let IdentityDecryptionKeyFormat = "identity"

public struct DecryptionKey {
    
    public let method :EncryptionMethod
    public let uri :URL
    public let initializationVector :(low: UInt64, high: UInt64)?
    public let keyFormat :String
    public let keyFormatVersions :[Int]?
    
    public init(method: EncryptionMethod, uri: URL, initializationVector: (low: UInt64, high: UInt64)? = nil, keyFormat: String = IdentityDecryptionKeyFormat, keyFormatVersions: [Int]? = nil) {
        self.method = method
        self.uri = uri
        self.initializationVector = initializationVector
        self.keyFormat = keyFormat
        self.keyFormatVersions = keyFormatVersions
    }
    
    private init() {
        self.method = .None
        self.uri = URL(string:"")!
        self.keyFormat = IdentityDecryptionKeyFormat
        
        keyFormatVersions = nil
        initializationVector = nil
    }
    
    public static let None :DecryptionKey = DecryptionKey.init()
    
}

extension DecryptionKey : Equatable {
    
    public static func ==(lhs: DecryptionKey, rhs: DecryptionKey) -> Bool {
        
        let formatVersionEquality :Bool
        
        switch (lhs.keyFormatVersions, rhs.keyFormatVersions) {
        case let (.some(a), .some(b)):
            formatVersionEquality = a == b
        case (.none, .none):
            formatVersionEquality = true
        default:
            formatVersionEquality = false
        }
        
        return lhs.method == rhs.method
            && lhs.uri == rhs.uri
            && lhs.initializationVector?.0 == rhs.initializationVector?.0
            && lhs.initializationVector?.1 == rhs.initializationVector?.1
            && lhs.keyFormat == rhs.keyFormat
            && formatVersionEquality
    }
    
}

public func setDecryptionKey(_ key :DecryptionKey, forSegments segments: [MediaSegment]) -> [MediaSegment] {
    return segments.map {
        var segment = $0
        segment.decryptionKey = key
        return segment
    }
}
