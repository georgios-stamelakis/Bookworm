//
//  BooksView.swift
//  Bookworm
//
//  Created by Georgios Stamelakis on 4/1/25.
//

import SwiftUI

struct BooksView: View {
    @StateObject private var viewModel = BooksViewModel()

    var body: some View {
        VStack(spacing: 16) {
            if viewModel.isLoading {
                ProgressView()
            } else {
                VStack {
                    Button("Books") {
                        Task {
                            await viewModel.getBooks()
                        }
                    }
                    .buttonStyle(.borderedProminent)
                }
                .padding()
            }
            if let errorMessage = viewModel.errorMessage {
                Text(errorMessage)
                    .foregroundColor(.red)
                    .multilineTextAlignment(.center)
            }
        }
        .padding()
        .navigationTitle("Books")
    }
}
