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

    func login() async {
        isLoading = true

        do {
            try await loginRepository.login(username: username, password: password)
        } catch let error as APIError {
            errorMessage = error.customDescription
        } catch {
            errorMessage = "Unknown error occurred."
        }

        isLoading = false
    }
}
