//
//  Logging.swift
//  HLSCore
//
//  Created by Fabian Canas on 4/15/18.
//  Copyright © 2018 Fabián Cañas. All rights reserved.
//

import Darwin
import Foundation

public protocol Logger {
    func log(_ string: String, level: HLSLogging.Level?)
}

public protocol LogOutputStream {
    mutating func write(_ string: String)
}

public enum HLSLogging {

    public enum Level: Comparable {

        public static func < (lhs: Level, rhs: Level) -> Bool {
            return lhs.value < rhs.value
        }

        case all
        case info
        case debug
        case error
        case fatal
        case off

        private var value: UInt {
            get {
                switch self {

                case .all:
                    return 0
                case .info:
                    return 1
                case .debug:
                    return 2
                case .error:
                    return 3
                case .fatal:
                    return 4
                case .off:
                    return UInt.max
                }
            }
        }
    }

    public struct StandardOutput: LogOutputStream {
        public init() {}
        public func write(_ string: String) {
            fputs(string, stdout)
        }
    }

    public struct StandardError: LogOutputStream {
        public init() {}
        public func write(_ string: String) {
            fputs(string, stderr)
        }
    }

    public class Default: Logger {

        private let thresholdLevel: Level
        private var errorOutput: LogOutputStream
        private var infoOutput: LogOutputStream

        public init(thresholdLevel: Level = Level.off, errorOut: LogOutputStream = StandardError(), infoOut: LogOutputStream = StandardOutput()) {
            self.thresholdLevel = thresholdLevel
            errorOutput = errorOut
            infoOutput = infoOut
        }

        public func log(_ string: String, level: Level?) {
            if (level ?? .info) >= thresholdLevel {
                infoOutput.write(string)
            } else {
                errorOutput.write(string)
            }
        }
    }

}
