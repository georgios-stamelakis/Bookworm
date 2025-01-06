//
//  LoginViewModel.swift
//  Bookworm
//
//  Created by Georgios Stamelakis on 4/1/25.
//

import Foundation
import Combine

@MainActor
class LoginViewModel: ObservableObject {
    @Published var username: String = ""
    @Published var password: String = ""
    @Published var isLoading: Bool = false
    @Published var isLoggedIn: Bool = false

    private var cancellables = Set<AnyCancellable>()
    @Published var isLoginButtonDisabled = true

    @Published var isPresentingError: Bool = false
    @Published var errorMessage: String = ""

    private let loginRepository: LoginRepository

    init(loginRepository: LoginRepository = DefaultLoginRepository()) {
        self.loginRepository = loginRepository

        $username
            .sink { _ in self.validateInputs() }
            .store(in: &cancellables)
        $password
            .sink { _ in self.validateInputs() }
            .store(in: &cancellables)
    }

    func validateInputs() {
        let isUsernameValid = CredentialValidators.validateUsername(self.username)
        let isPasswordValid = CredentialValidators.validatePassword(self.password)

        self.isLoginButtonDisabled = !(isUsernameValid && isPasswordValid)
    }


    func login() {
        isLoading = true
        Task {
            defer { isLoading = false }
            do {
                try await loginRepository.login(username: username, password: password)
                isLoggedIn = true
            } catch let error as APIError {
                triggerError(withDescription: error.userReadableDescription)
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
