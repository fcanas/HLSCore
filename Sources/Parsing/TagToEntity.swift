//
//  TagToEntity.swift
//  HLSCore
//
//  Created by Fabian Canas on 10/8/16.
//  Copyright © 2016 Fabian Canas. All rights reserved.
//

import Foundation
import Types

/// Builds stand-alone structs from an AnyTag enum
///
/// May not be useful beyond development and initial testing.
func entity(fromTag tag: AnyTag) -> Any? {

    switch tag {
    case let .playlist(playlist):
        switch playlist {
        case .version(_):
            return nil
        case .independentSegments:
            return nil
        case let .startIndicator(startIndicator):
            return startIndicator
        case .url(_):
            return nil
        case .comment(_):
            return nil
        }
    case .media(_):
        return nil
    case let .segment(segment):
        switch segment {
        case .inf(_, _):
            return nil
        case .byteRange(_):
            return nil
        case .discontinuity:
            return nil
        case let .key(key):
            return key
        case .map(_):
            return nil
        case .programDateTime(_):
            return nil
        case .dateRange(_):
            return nil
        }
    case .master(_):
        return nil
    }

}
