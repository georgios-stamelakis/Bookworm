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
        NavigationStack {
            ScrollView {
                if viewModel.isLoading {
                    ProgressView()
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                } else {
                    LazyVStack(alignment: .leading, spacing: 20) {
                        ForEach(viewModel.groupedBooks.keys.sorted(by: >), id: \.self) { year in
                            GroupedBooksSection(year: year, books: viewModel.groupedBooks[year] ?? [])
                        }
                    }
                }
            }
            .navigationTitle("Books")
            .onAppear {
                Task {
                    await viewModel.getBooks()
                }
            }
            .safeAreaInset(edge: .bottom) {
                Color.clear.frame(height: 30)
            }
        }
    }
}

struct GroupedBooksSection: View {
    var year: Int
    var books: [Book]

    var body: some View {
        Section(header: Text(String(year))
            .font(.title)
            .bold()
            .padding(.horizontal)
        ) {
            ScrollView(.horizontal, showsIndicators: false) {
                LazyHStack(spacing: 15) {
                    ForEach(books) { book in
                        BookItemView(book: book)
                            .frame(width: 180, height: 250)
                    }
                }
                .padding(.horizontal)
            }
        }
    }
}

