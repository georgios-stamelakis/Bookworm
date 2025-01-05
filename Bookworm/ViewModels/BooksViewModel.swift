//
//  BooksViewModel.swift
//  Bookworm
//
//  Created by Georgios Stamelakis on 4/1/25.
//

import Foundation

@MainActor
class BooksViewModel: ObservableObject {
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?
    @Published var groupedBooks: [Int: [Book]] = [:]

    private let booksRepository: BooksRepository

    init(booksRepository: BooksRepository = DefaultBooksRepository()) {
        self.booksRepository = booksRepository
    }

    func getBooks() async {
        isLoading = true
        defer { isLoading = false }

        do {
            let books = try await booksRepository.fetchBooks()
            groupedBooks = groupBooksByYear(books: books)
        } catch let error as APIError {
            errorMessage = error.customDescription
        } catch {
            errorMessage = "Unknown error occurred."
        }
    }

    private func groupBooksByYear(books: [Book]) -> [Int: [Book]] {
        let calendar = Calendar.current
        return Dictionary(grouping: books) { book in
            calendar.component(.year, from: book.dateReleased)
        }
    }
}
