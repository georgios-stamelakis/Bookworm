//
//  BooksRepository.swift
//  Bookworm
//
//  Created by Georgios Stamelakis on 4/1/25.
//

import Foundation

protocol BooksRepository {
    func fetchBooks() async throws -> [Book]
}

class DefaultBooksRepository: BooksRepository {

    var tokenStorage: TokenStorageProtocol

    init(tokenStorage: TokenStorageProtocol = KeychainTokenManager()) {
        self.tokenStorage = tokenStorage
    }

    func fetchBooks() async throws -> [Book] {

        let booksRequest = BooksRequest()
        let booksClient = BooksClient()

            let booksResponse = try await booksClient.fetchBooks(with: booksRequest)
            return booksResponse.books
    }
}
