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
        ZStack {
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
                        viewModel.login()
                        sharedViewModel.isLoggedIn = true
                    }
                    .disabled(viewModel.isLoginButtonDisabled)
                    .buttonStyle(.borderedProminent)
                }

            }

            VStack {
                ErrorView(isVisible: $viewModel.isPresentingError, message: viewModel.errorMessage)
                    .padding(.top, 10)
                Spacer()

            }
            .animation(.easeInOut, value: viewModel.isPresentingError)

        }
        .padding()
        .navigationTitle("Login")
    }
}
