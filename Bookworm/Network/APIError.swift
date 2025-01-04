//
//  APIError.swift
//  Bookworm
//
//  Created by Georgios Stamelakis on 4/1/25.
//

import Foundation

enum APIError: Error {

    case responseUnsuccessful(description: String)
    case requestFailed(description: String)
    case jsonConversionFailure(description: String)
    case unauthorized(description: String)

    var customDescription: String {
        switch self {
        case .requestFailed(let description): return "APIError - Request Failed -> \(description)"
        case .responseUnsuccessful(let description): return "APIError - Response Unsuccessful status code -> \(description)"
        case .jsonConversionFailure(let description): return "APIError - JSON Conversion Failure -> \(description)"
        case .unauthorized(let description): return "APIError - Access Denied -> \(description)"
        }
    }
}
