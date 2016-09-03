//
//  File.swift
//  Strip
//
//  Created by Fabian Canas on 8/1/16.
//  Copyright © 2016 Fabian Canas. All rights reserved.
//

import Foundation
import Utilities

extension FileManager {
    
    /**
     * Moves a file from one URL to another creating intermediate directories
     * and replacing the file at the destination.
     * - parameter fromURL: source URL
     * - parameter toURL: destination URL
     */
    func moveFileFrom(_ fromURL: URL, toURL destination: URL) {

        var destinationComponents = URLComponents(url: destination, resolvingAgainstBaseURL: false)!

        destinationComponents.path = destinationComponents.path.replacingOccurrences(of: "//", with: "/")

        let dest = destinationComponents.url!

        if !fileExists(atPath: dest.path.deepestDirectoryPath()) {
            // target directory does not exist. create it.
            do {
                try self.createDirectory(at: dest.directoryURL(), withIntermediateDirectories: true, attributes: [:])
            } catch {
                print("error creating intermediate directories")
            }
        }
        
        do {
            try self.moveItem(at: fromURL, to: dest)
        } catch let e as NSError {
            do {
                try self.replaceItem(at: dest, withItemAt: fromURL, backupItemName: nil, options: FileManager.ItemReplacementOptions(), resultingItemURL: nil)
            } catch let er as NSError {
                print("\(e.localizedDescription)")
                print("bail: \(er)")
                return
            }
        }
    }
}
