//
//  LoginViewModel.swift
//  Bookworm
//
//  Created by Georgios Stamelakis on 4/1/25.
//

import Foundation

@MainActor
class LoginViewModel: ObservableObject {
    @Published var username: String = ""
    @Published var password: String = ""
    @Published var isLoading: Bool = false

    @Published var isPresentingError: Bool = false
    @Published var errorMessage: String = ""

    var isLoginButtonDisabled: Bool {
        username.isEmpty || password.isEmpty || isLoading
    }

    private let loginRepository: LoginRepository

    init(loginRepository: LoginRepository = DefaultLoginRepository()) {
        self.loginRepository = loginRepository
    }

    func login() {
        isLoading = true

        Task {
            defer { isLoading = false }

            do {
                try await loginRepository.login(username: username, password: password)
            } catch let error as APIError {
                triggerError(withDescription: error.customDescription)
            } catch {
                triggerError(withDescription: "Unknown error occurred.")
            }

        }

    }

    private func triggerError(withDescription errorDescription: String) {
        errorMessage = errorDescription
        isPresentingError = true
    }
}
