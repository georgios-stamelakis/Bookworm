//
//  PopupView.swift
//  Bookworm
//
//  Created by Georgios Stamelakis on 6/1/25.
//

import SwiftUI

struct PopupView: View {
    @Binding var isVisible: Bool
    let location: CGPoint
    let content: AnyView

    var body: some View {
        if isVisible {
            GeometryReader { geometry in
                ZStack {
                    // Background overlay
                    Color.black.opacity(0.4)
                        .ignoresSafeArea(edges: .all)
                        .onTapGesture {
                            isVisible = false
                        }

                    // Popup content
                    content
                        .frame(maxWidth: 200)
                        .background(Color.white)
                        .cornerRadius(15)
                        .shadow(radius: 10)
                        .position(adjustedPosition(for: location, in: geometry))

                }
            }
        }
    }

    private func adjustedPosition(for location: CGPoint, in geometry: GeometryProxy) -> CGPoint {
        let safeFrame = geometry.safeAreaInsets
        let screenSize = geometry.size

        let popupWidth: CGFloat = 200

        // Its quite off when we use the same y - adjustments after testing...
        let calculatedY = location.y - 75

        let safeX = max(
            safeFrame.leading + popupWidth / 2,
            min(location.x, screenSize.width - safeFrame.trailing - popupWidth / 2)
        )

        return CGPoint(x: safeX, y: calculatedY)
    }
}
