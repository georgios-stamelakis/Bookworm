//
//  LoginClient.swift
//  Bookworm
//
//  Created by Georgios Stamelakis on 4/1/25.
//

import Foundation

class LoginClient: APIClient {
    let session: URLSession

    init() {
        self.session = URLSession(configuration: .default)
    }

    func login(with endpoint: LoginRequest) async throws -> LoginResponse {
        guard let request = endpoint.request else {
            throw APIError.requestFailed(description: "Unable to construct a valid request!")
        }

        let response = try await fetch(with: request, decodingType: LoginResponse.self)

        return response
    }

}
