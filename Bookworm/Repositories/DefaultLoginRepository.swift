//
//  DefaultLoginRepository.swift
//  Bookworm
//
//  Created by Georgios Stamelakis on 4/1/25.
//

import Foundation

protocol LoginRepository {
    func login(username: String, password: String) async throws
}

class DefaultLoginRepository: LoginRepository {

    func login(username: String, password: String) async throws {

        let loginRequest = LoginRequest(username: username, password: password)
        let loginClient = LoginClient()

        let loginResponse = try await loginClient.login(with: loginRequest)
    }
}
