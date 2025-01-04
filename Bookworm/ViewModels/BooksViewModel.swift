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

    private let booksRepository: BooksRepository

    init(booksRepository: BooksRepository = DefaultBooksRepository()) {
        self.booksRepository = booksRepository
    }

    func getBooks() async {
        do {
            try await booksRepository.getBooks()
        } catch let error as APIError {
            errorMessage = error.customDescription
        } catch {
            errorMessage = "Unknown error occurred."
        }
    }
}
