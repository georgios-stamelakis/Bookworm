//
//  LoginResponse.swift
//  Bookworm
//
//  Created by Georgios Stamelakis on 4/1/25.
//

import Foundation

struct LoginResponse: Decodable {
    let expiresIn: Int
    let tokenType: String
    let refreshToken: String
    let accessToken: String

    private enum CodingKeys: String, CodingKey {
        case expiresIn = "expires_in"
        case tokenType = "token_type"
        case refreshToken = "refresh_token"
        case accessToken = "access_token"
    }
}
