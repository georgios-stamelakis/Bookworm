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

    var tokenStorage: TokenStorageProtocol

    init(tokenStorage: TokenStorageProtocol = KeychainTokenManager()) {
        self.tokenStorage = tokenStorage
    }

    func login(username: String, password: String) async throws {

        let loginRequest = LoginRequest(username: username, password: password)
        let loginClient = LoginClient()

        let loginResponse = try await loginClient.login(with: loginRequest)

        let tokenData = TokenData(tokenType: loginResponse.tokenType, refreshToken: loginResponse.refreshToken, accessToken: loginResponse.accessToken)
        try tokenStorage.saveTokenData(tokenData)
    }
}
