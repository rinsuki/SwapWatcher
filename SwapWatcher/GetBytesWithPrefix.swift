//
//  GetBytesWithPrefix.swift
//  SwapWatcher
//
//  Created by user on 2019/12/13.
//  Copyright © 2019 rinsuki. All rights reserved.
//

import Foundation

func getBytesWithPrefix(bytes: UInt64) -> String {
    let memUsedPrefix: Int
    let memUsedStr: String
    if bytes >= 1024 * 1024 * 1024 {
        memUsedPrefix = 1024 * 1024 * 1024
        memUsedStr = "GB"
    } else if bytes >= 1024 * 1024 {
        memUsedPrefix = 1024 * 1024
        memUsedStr = "MB"
    } else if bytes >= 1024 {
        memUsedPrefix = 1024
        memUsedStr = "KB"
    } else {
        memUsedPrefix = 1
        memUsedStr = " bytes"
    }
    
    return String(format: "%.2f", Double(bytes) / Double(memUsedPrefix)) + memUsedStr
}
