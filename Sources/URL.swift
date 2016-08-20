//
//  URL.swift
//  HLSCore
//
//  Created by Fabian Canas on 8/14/16.
//  Copyright © 2016 Fabian Canas. All rights reserved.
//

import Foundation

extension URL {
    
    /**
     * Called on an absolute URL, returns a new relative URL based on the parameter.
     * for example:
     * (http://example.com/a/test).relativeURL(http://example.com/a/) -> test
     */
    func relativeURL(baseURL: URL) -> URL {
        let baseString = baseURL.absoluteString
        let selfString = absoluteString
        if selfString.hasPrefix(baseString) {
            var relativeString = selfString
            relativeString.removeSubrange(baseString.fullRange)
            return URL(string: relativeString, relativeTo: baseURL) ?? self
        }
        return self
    }
    
    func directoryURL() -> URL {
        var components = URLComponents(url: self, resolvingAgainstBaseURL: false)!
        components.path = path.deepestDirectoryPath() ?? "/"
        return components.url!
    }
}
