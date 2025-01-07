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

    @State private var isUsernamePopupViewActive: Bool = false
    @State private var isPasswordPopupViewActive: Bool = false
    @State private var isPasswordVisible: Bool = false

    @State private var tapLocation: CGPoint = .zero

    var body: some View {
        ZStack {
            VStack {
                Spacer()

                Text("Sign in to\nBookworm")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .multilineTextAlignment(.center)
                    .foregroundStyle(AppColors.secondaryColor)
                    .shadow(color: .primary.opacity(0.3), radius: 5, x: 0, y: 2)

                // Username Field
                VStack      {
                    ZStack {
                        RoundedRectangle(cornerRadius: 25)
                            .fill(AppColors.mainColor)
                            .shadow(color: .primary.opacity(0.3), radius: 5, x: 0, y: 2)

                        HStack {
                            Image(systemName: "person.fill")
                                .foregroundColor(.gray)
                                .imageScale(.large)
                                .padding(.leading, 10)

                            TextField("", text: $viewModel.username, prompt: Text("Username").foregroundColor(.gray))
                                .autocapitalization(.none)
                                .disableAutocorrection(true)
                                .padding(.leading, 8)
                                .font(.system(size: 20))
                                .foregroundStyle(.black)
                                .shadow(color: .black.opacity(0.1), radius: 5, x: 0, y: 2)

                            Image(systemName: "info.circle.fill")
                                .foregroundColor(.gray)
                                .imageScale(.large)
                                .padding(.leading, 10)
                                .onTapGesture(coordinateSpace: .global) { location in
                                    tapLocation = location
                                    isUsernamePopupViewActive = true
                                }

                        }
                        .padding(16)
                    }
                    .frame(height: 60)
                    .padding(.top, 20)

                    // Password Field
                    ZStack {
                        RoundedRectangle(cornerRadius: 25)
                            .fill(AppColors.mainColor)
                            .shadow(color: .primary.opacity(0.3), radius: 5, x: 0, y: 2)

                        HStack {
                            Image(systemName: "lock.fill")
                                .foregroundColor(.gray)
                                .imageScale(.large)
                                .padding(.leading, 10)

                            if !isPasswordVisible {
                                SecureField("", text: $viewModel.password, prompt: Text("Password").foregroundColor(.gray))
                                    .autocapitalization(.none)
                                    .disableAutocorrection(true)
                                    .padding(.leading, 8)
                                    .font(.system(size: 20))
                                    .foregroundStyle(.black)
                                    .shadow(color: .black.opacity(0.1), radius: 5, x: 0, y: 2)
                            } else {
                                TextField("", text: $viewModel.password, prompt: Text("Password").foregroundColor(.gray))
                                    .autocapitalization(.none)
                                    .disableAutocorrection(true)
                                    .padding(.leading, 8)
                                    .font(.system(size: 20))
                                    .foregroundStyle(.black)
                                    .shadow(color: .black.opacity(0.1), radius: 5, x: 0, y: 2)
                            }

                            Button(action: {
                                isPasswordVisible.toggle()
                            }) {
                                Image(systemName: isPasswordVisible ? "eye.slash" : "eye")
                                    .foregroundColor(.gray)
                            }

                            Image(systemName: "info.circle.fill")
                                .foregroundColor(.gray)
                                .imageScale(.large)
                                .padding(.leading, 10)
                                .onTapGesture(coordinateSpace: .global) { location in
                                    tapLocation = location
                                    isPasswordPopupViewActive = true
                                }
                        }
                        .padding(16)
                    }
                    .frame(height: 60)
                    .padding(.top, 20)

                }

                Button(action: {
                    viewModel.login()
                }) {
                    Text("Login")
                        .font(.system(size: 24, weight: .bold, design: .default))
                        .foregroundColor(.white)

                        .frame(minWidth: 0, maxWidth: .infinity)
                        .padding()
                        .shadow(color: .black.opacity(0.3), radius: 5, x: 0, y: 2)

                        .background(
                            RoundedRectangle(cornerRadius: 25)
                                .fill(viewModel.isLoginButtonDisabled ? Color.gray : AppColors.secondaryColor)
                                .shadow(color: .primary.opacity(0.3), radius: 5, x: 0, y: 2)
                        )

                }
                .disabled(viewModel.isLoginButtonDisabled)
                .padding(.top, 60)

                Spacer()

            }
            .padding()

            PopupView(isVisible: $isUsernamePopupViewActive, location: tapLocation, content: AnyView(
                UsernameRequirementsView()
            ))

            PopupView(isVisible: $isPasswordPopupViewActive, location: tapLocation, content: AnyView(
                PasswordRequirementsView()
            ))

            VStack {
                ErrorView(isVisible: $viewModel.isPresentingError, message: viewModel.errorMessage)
                    .padding(.top, 10)
                Spacer()

            }
            .animation(.easeInOut, value: viewModel.isPresentingError)
            .animation(.easeInOut, value: isUsernamePopupViewActive)
            .animation(.easeInOut, value: isPasswordPopupViewActive)

        }
        .navigationTitle("Login")
        .onChange(of: viewModel.isLoggedIn) { newIsLoggedInState in
            if newIsLoggedInState {
                sharedViewModel.isLoggedIn = true
            }
        }
        .accentColor(AppColors.secondaryColor)
    }
}
