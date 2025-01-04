//
//  LoginView.swift
//  Bookworm
//
//  Created by Georgios Stamelakis on 4/1/25.
//

import SwiftUI

struct LoginView: View {
    @EnvironmentObject var sharedViewModel: SharedViewModel
    @StateObject private var viewModel = LoginViewModel()

    var body: some View {
        VStack(spacing: 16) {
            TextField("Username", text: $viewModel.username)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .autocapitalization(.none)
                .disableAutocorrection(true)

            SecureField("Password", text: $viewModel.password)
                .textFieldStyle(RoundedBorderTextFieldStyle())

            if viewModel.isLoading {
                ProgressView()
            } else {
                Button("Login") {
                    Task {
                        await viewModel.login()
                        sharedViewModel.isLoggedIn = true
                    }
                }
                .disabled(viewModel.isLoginButtonDisabled)
                .buttonStyle(.borderedProminent)
            }
            if let errorMessage = viewModel.errorMessage {
                Text(errorMessage)
                    .foregroundColor(.red)
                    .multilineTextAlignment(.center)
            }
        }
        .padding()
        .navigationTitle("Login")
    }
}
