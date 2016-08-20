//
//  String.swift
//  HLSCore
//
//  Created by Fabian Canas on 8/19/16.
//  Copyright © 2016 Fabian Canas. All rights reserved.
//

import Foundation

extension String {
    
    var fullRange :Range<Index> {
        get {
            return Range(uncheckedBounds: (lower: startIndex, upper: endIndex))
        }
    }
    
    func deepestDirectoryPath() -> String {
        if self.hasSuffix("/") {
            return self
        }
        guard let lastSlashIndex = self.range(of: "/", options: .backwards)?.lowerBound else {
            return "/"
        }
        
        return self.substring(to: self.index(after: lastSlashIndex))
    }
    
}
