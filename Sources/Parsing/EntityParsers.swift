//
//  EntityParsers.swift
//  HLSCore
//
//  Created by Fabian Canas on 9/18/16.
//  Copyright © 2016 Fabian Canas. All rights reserved.
//

import Foundation
import Types

/**
 Entities that may be composed of more than one tag
 */

let MediaEntityParser = MediaSegment.init <^> (EXTINF <<& (newline *> EXTXBYTERANGE).optional <<& (newline *> url))
