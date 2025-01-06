//
//  DebugLogger.swift
//  Bookworm
//
//  Created by Georgios Stamelakis on 6/1/25.
//

class DebugLogger {
    class func log(_ message: String) {
#if DEBUG
        print(message)
#endif
    }
}
