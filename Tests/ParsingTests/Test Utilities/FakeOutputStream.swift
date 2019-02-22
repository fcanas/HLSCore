//
//  FakeOutputStream.swift
//  FFCLog
//
//  Created by Fabián Cañas on 2/21/19.
//

import FFCLog

class FakeOutputStream: LogOutputStream {

    var logs: [String] = []

    func write(_ string: String) {
        logs.append(string)
    }

}
