//
//  HTTPHeader.swift
//  Bookworm
//
//  Created by Georgios Stamelakis on 4/1/25.
//

import Foundation

enum HTTPHeader {
    case contentType(String)
    case contentLength(String)
    case authorization(String)

    var header: (field: String, value: String) {
        switch self {
        case .contentType(let value): return (field: "Content-Type", value: value)
        case .contentLength(let value): return (field: "Content-Length", value: value)
        case .authorization(let value): return (field: "Authorization", value: value)
        }
    }
}
