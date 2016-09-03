//
//  URL.swift
//  Strip
//
//  Created by Fabian Canas on 8/1/16.
//  Copyright © 2016 Fabian Canas. All rights reserved.
//

import Foundation

extension URL {
    enum HLSResource {
        case Playlist
        case Media
        
        init(string: String) {
            
            enum PlaylistTypes : String {
                case m3u8, m3u
            }
            
            self = PlaylistTypes(rawValue: string.lowercased()) == nil ? .Media : .Playlist
        }
    }
    
    var type :HLSResource? {
        return HLSResource(string: fileExtension)
    }
    
    public var fileExtension :String {
        get {
            return self.path.components(separatedBy: ".").last ?? ""
        }
    }
}
