//
//  String.swift
//  HLSCore
//
//  Created by Fabian Canas on 8/19/16.
//  Copyright © 2016 Fabian Canas. All rights reserved.
//

import Foundation

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
