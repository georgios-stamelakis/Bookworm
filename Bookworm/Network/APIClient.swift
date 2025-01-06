//
//  APIClient.swift
//  Bookworm
//
//  Created by Georgios Stamelakis on 4/1/25.
//

import Foundation

protocol APIClient {
    var session: URLSession { get }
    func fetch<T: Decodable>(with request: URLRequest, decodingType: T.Type) async throws -> T
}

extension APIClient {
    func fetch<T: Decodable>(with request: URLRequest, decodingType: T.Type) async throws -> T {
        let (data, response) = try await session.data(for: request)

        guard let httpResponse = response as? HTTPURLResponse else {
            throw APIError.requestFailed(description: "Invalid response")
        }

        switch httpResponse.statusCode {
        case 200:
            do {
                let jsonDecoder = JSONDecoder()
                jsonDecoder.dateDecodingStrategy = .iso8601
                return try jsonDecoder.decode(decodingType, from: data)
            } catch {
                throw APIError.jsonConversionFailure(description: error.localizedDescription)
            }
        case 401:
            DebugLogger.log("Bad HTTP Response Code: \(httpResponse.statusCode)")
            throw APIError.unauthorized(description: "Authorization failed")
        default:
            DebugLogger.log("Bad HTTP Response Code: \(httpResponse.statusCode)")
            throw APIError.responseUnsuccessful(description: "Status code: \(httpResponse.statusCode)")
        }
    }

}
