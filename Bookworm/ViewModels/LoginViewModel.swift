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
        let isUsernameValid = validateUsername(self.username)
        let isPasswordValid = validatePassword(self.password)

        // The login button is enabled only if both username and password are valid
        self.isLoginButtonDisabled = !(isUsernameValid && isPasswordValid)
    }

    private func validateUsername(_ userID: String) -> Bool {
        let pattern = "^[A-Z]{2}[0-9]{4}$"
        do {
            let regex = try NSRegularExpression(pattern: pattern)
            let range = NSRange(location: 0, length: userID.utf16.count)
            return regex.firstMatch(in: userID, options: [], range: range) != nil
        } catch {
            DebugLogger.log("Invalid regex: \(error.localizedDescription)")
            return false
        }
    }

    private func validatePassword(_ password: String) -> Bool {
        let pattern = "^(?=.*[A-Z].*[A-Z])(?=.*[!@#$%^&*(),.?\":{}|<>])(?=.*\\d.*\\d)(?=.*[a-z].*[a-z].*[a-z])[A-Za-z\\d!@#$%^&*(),.?\":{}|<>]{8,}$"
        do {
            let regex = try NSRegularExpression(pattern: pattern)
            let range = NSRange(location: 0, length: password.utf16.count)
            return regex.firstMatch(in: password, options: [], range: range) != nil
        } catch {
            DebugLogger.log("Invalid regex: \(error.localizedDescription)")
            return false
        }
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
