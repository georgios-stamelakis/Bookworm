//
//  KeychainTokenManager.swift
//  Bookworm
//
//  Created by Georgios Stamelakis on 4/1/25.
//


/*
sample LoginResponse
{
    "expires_in": 3600,
    "token_type": "Bearer",
    "refresh_token": "T1amGR21.IdKM.5ecbf91162691e15913582bf2662e0",
    "access_token": "T1amGT21.Idup.298885bf38e99053dca3434eb59c6aa"
}
*/

import Foundation

protocol TokenStorageProtocol {
    func saveTokenData(_ tokenData: TokenData) throws
    func retrieveAccessToken() -> String?
    func retrieveRefreshToken() -> String?
    func clearTokens() throws
}

struct TokenData: Codable {
    let tokenType: String
    let refreshToken: String
    let accessToken: String
}

class KeychainTokenManager: TokenStorageProtocol {
    let tokenKey: String = "TokenResponse"

    func saveTokenData(_ tokenData: TokenData) throws {
        let data = try JSONEncoder().encode(tokenData)
        KeychainHelper.save(data: data, forKey: tokenKey)
    }

    func retrieveTokenType() -> String? {
        guard let data = KeychainHelper.retrieveData(forKey: tokenKey),
              let tokenResponse = try? JSONDecoder().decode(TokenData.self, from: data) else {
            return nil
        }
        return tokenResponse.tokenType
    }

    func retrieveAccessToken() -> String? {
        guard let data = KeychainHelper.retrieveData(forKey: tokenKey),
              let tokenResponse = try? JSONDecoder().decode(TokenData.self, from: data) else {
            return nil
        }
        return tokenResponse.accessToken
    }

    func retrieveRefreshToken() -> String? {
        guard let data = KeychainHelper.retrieveData(forKey: tokenKey),
              let tokenResponse = try? JSONDecoder().decode(TokenData.self, from: data) else {
            return nil
        }
        return tokenResponse.refreshToken
    }

    func clearTokens() throws {
        KeychainHelper.deleteData(forKey: tokenKey)
    }
}
