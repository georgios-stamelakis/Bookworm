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
    @Published var errorMessage: String?

    var isLoginButtonDisabled: Bool {
        username.isEmpty || password.isEmpty || isLoading
    }

    private let loginRepository: LoginRepository
    private let booksRepository: BooksRepository

    init(loginRepository: LoginRepository = DefaultLoginRepository(), booksRepository: BooksRepository = DefaultBooksRepository()) {
        self.loginRepository = loginRepository
        self.booksRepository = booksRepository
    }

    func login() async {
        isLoading = true
        errorMessage = nil

        do {
            try await loginRepository.login(username: username, password: password)
        } catch let error as APIError {
            errorMessage = error.customDescription
        } catch {
            errorMessage = "Unknown error occurred."
        }

        isLoading = false
    }

    func getBooks() async {
        do {
            try await booksRepository.getBooks()
        } catch let error as APIError {
            errorMessage = error.customDescription
        } catch {
            errorMessage = "Unknown error occurred."
        }
    }
}
