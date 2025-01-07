//
//  SplashScreenView.swift
//  Bookworm
//
//  Created by Georgios Stamelakis on 7/1/25.
//



import SwiftUI

struct SplashScreenView: View {
    @State private var isActive = false
    @State private var scaleEffect = 0.8

    var body: some View {
        if isActive {
            ContentView()
        } else {
            VStack {
                Image(systemName: "books.vertical.circle.fill")
                    .resizable()
                    .frame(width: 200, height: 200)
                    .scaleEffect(scaleEffect)
                    .shadow(color: .primary.opacity(0.1), radius: 5, x: 0, y: 2)
                    .onAppear {
                        withAnimation(.easeIn(duration: 1.0)) {
                            self.scaleEffect = 1.0
                        }
                    }

                Text("Welcome to Bookworm")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .shadow(color: .primary.opacity(0.1), radius: 5, x: 0, y: 2)
            }
            .onAppear {
                DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                    withAnimation {
                        self.isActive = true
                    }
                }
            }
            .foregroundStyle(AppColors.mainColor)
        }
    }
}
