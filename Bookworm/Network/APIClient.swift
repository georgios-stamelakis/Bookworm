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

#if DEBUG
        print("HTTP RESPONSE CODE: \(httpResponse.statusCode)")
#endif

        switch httpResponse.statusCode {
        case 200:
            do {
                return try JSONDecoder().decode(decodingType, from: data)
            } catch {
                throw APIError.jsonConversionFailure(description: error.localizedDescription)
            }
        case 401:
            throw APIError.unauthorized(description: "Authorization failed")
        default:
            throw APIError.responseUnsuccessful(description: "Status code: \(httpResponse.statusCode)")
        }
    }

}

