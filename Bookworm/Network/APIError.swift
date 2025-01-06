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

    var userReadableDescription: String {
        switch self {
        case .requestFailed:
            return "There was an issue with the request. Please try again."
        case .responseUnsuccessful:
            return "The server returned an error. Please try again later."
        case .jsonConversionFailure:
            return "We encountered an issue processing the data. Please try again."
        case .unauthorized:
            return "Wrong username or password. Please check your credentials and try again."
        }
    }

}
