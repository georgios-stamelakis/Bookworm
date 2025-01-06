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
                            GroupedBooksSection(year: year, books: viewModel.groupedBooks[year] ?? [:]) { book in
                                toggleDownload(for: book)
                            }
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
    var books: [Int : Book]

    let onBookTapped: (Book) -> Void

    var body: some View {
        Section(header: Text(String(year))
            .font(.title)
            .bold()
            .padding(.horizontal)
        ) {
            ScrollView(.horizontal, showsIndicators: false) {
                LazyHStack(spacing: 15) {
                    ForEach(books.keys.sorted(), id: \.self) { key in
                        if let book = books[key] {
                            BookItemView(book: book) {
                                onBookTapped(book)
                            }
                            .frame(width: 180, height: 250)
                        }
                    }
                    .padding(.horizontal)
                }
            }
        }
    }

}

private extension BooksView {
    func toggleDownload(for book: Book) {
        Task {
            try? await viewModel.download(book)
        }
    }
}
