//
//  URL.swift
//  HLSCore
//
//  Created by Fabian Canas on 8/14/16.
//  Copyright © 2016 Fabian Canas. All rights reserved.
//

import Foundation
import FFCParserCombinator

extension URL {

    /**
     * Called on an absolute URL, returns a new relative URL based on the parameter.
     * for example:
     * (http://example.com/a/test).relativeURL(http://example.com/a/) -> test
     *
     * [RFC 1808](https://tools.ietf.org/html/rfc1808) is relevant, but not strictly followed.
     */
    func relativeURL(baseURL: URL) -> URL {
        let baseString = baseURL.absoluteString
        let selfString = absoluteString

        if selfString.hasPrefix(baseString) {
            var relativeString = selfString
            relativeString.removeSubrange(baseString.fullRange)
            return URL(string: relativeString, relativeTo: baseURL) ?? self
        } else {

            let commonPrefix = selfString.commonPrefix(with: baseString)

            // By checking the scheme, user, host, and port are equal, we avoid
            // the problem of creating relative URLs where they're not 
            // appropriate, and that further checking is effectively on the path
            guard baseURL.scheme == self.scheme
               && baseURL.user == self.user
               && baseURL.host == self.host
               && baseURL.port == self.port else {
                return self
            }

            // TODO : how to handle query and fragments?

            let strippedBaseString = baseString.replacingCharacters(in: commonPrefix.fullRange, with: "")
            let strippedSelfString = selfString.replacingCharacters(in: commonPrefix.fullRange, with: "")

            let numberOfDirectorySlashes = strippedBaseString.reduce(0, { (count: Int, character) -> Int in
                if character == "/" {
                    return count + 1
                }
                return count
            })

            var prefix = ""
            for _ in 0..<numberOfDirectorySlashes {
                prefix += "../"
            }

            if let result = URL(string: prefix + strippedSelfString, relativeTo: baseURL) {
                return result
            }
        }

        return self
    }

    public func directoryURL() -> URL {
        var components = URLComponents(url: self, resolvingAgainstBaseURL: false)!
        components.path = path.deepestDirectoryPath()
        return components.url!
    }
}

extension String {

    func deepestDirectoryPath() -> String {
        if self.hasSuffix("/") {
            return self
        }
        guard let lastSlashIndex = self.range(of: "/", options: .backwards)?.lowerBound else {
            return "/"
        }

        return String(self[..<self.index(after: lastSlashIndex)])
    }

}
