//
//  LoginRepository.swift
//  Bookworm
//
//  Created by Georgios Stamelakis on 4/1/25.
//

import Foundation

protocol LoginRepository {
    func login(username: String, password: String) async throws
}


class DummyLoginRepository: LoginRepository {
    func login(username: String, password: String) async throws {
        try await Task.sleep(nanoseconds: 2_000_000_000)

        if username == "test" && password == "password" {
        } else {
            throw DummyLoginError.invalidCredentials
        }
    }
}

enum DummyLoginError: LocalizedError {
    case invalidCredentials

    var errorDescription: String? {
        switch self {
        case .invalidCredentials:
            return "Invalid username or password."
        }
    }
}
