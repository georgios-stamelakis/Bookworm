//
//  ErrorView.swift
//  Bookworm
//
//  Created by Georgios Stamelakis on 6/1/25.
//

import SwiftUI

struct ErrorView: View {
    @Binding var isVisible: Bool
    let message: String
    let duration: TimeInterval = 3

    @Environment(\.scenePhase) private var scenePhase

    private func startDismissTimer() {
           DispatchQueue.main.asyncAfter(deadline: .now() + duration) {
               isVisible = false
           }
       }

    var body: some View {
        if isVisible {
            HStack(spacing: 10) {
                ZStack {
                    Image(systemName: "exclamationmark.circle.fill")
                        .font(.title2)
                        .foregroundColor(.white)
                }

                Text(message)
                    .foregroundColor(.white)
                    .multilineTextAlignment(.leading)
                    .shadow(color: .black.opacity(0.6), radius: 2, x: 1, y: 1)
            }
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color.red)
                    .shadow(color: .black.opacity(0.3), radius: 5, x: 0, y: 2)
            )
            .transition(.opacity)
            .onAppear {
                startDismissTimer()
            }
            .onChange(of: scenePhase) { newPhase in
                if newPhase == .background {
                    isVisible = false
                }
            }
        }
    }

}
