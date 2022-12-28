//
//  DLog.swift
//  Copyrighted
//
//  Created by Sergey Gruzdev on 13.11.2017.
//  Copyright © 2017 OTG. All rights reserved.
//

import Foundation

public func DLog(_ messages: Any?..., fullPath: String = #file, line: Int = #line, functionName: String = #function) {
    #if DEBUG
        let file = NSURL.fileURL(withPath: fullPath)
        struct Holder {
            static let dateFormatter: DateFormatter = {
                var formatter = DateFormatter()
                formatter.dateFormat = "yyyy-MM-dd HH:mm:ss.SSSZ"
                return formatter
            }()
        }
        let date = Date()
        for message in messages {
            print("\(Holder.dateFormatter.string(from: date))"); debugPrint("\(file.pathComponents.last!):\(line) -> \(functionName)", message ?? ("<nil>" as Any) , separator: " ", terminator:"\n\n")
        }
    #endif
}
