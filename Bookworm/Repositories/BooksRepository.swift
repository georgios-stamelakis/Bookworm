//
//  BooksRepository.swift
//  Bookworm
//
//  Created by Georgios Stamelakis on 4/1/25.
//

import Foundation

protocol BooksRepository {
    func getBooks() async throws
}

class DefaultBooksRepository: BooksRepository {

    var tokenStorage: TokenStorageProtocol

    init(tokenStorage: TokenStorageProtocol = KeychainTokenManager()) {
        self.tokenStorage = tokenStorage
    }

    func getBooks() async throws {

        let booksRequest = BooksRequest()
        let booksClient = BooksClient()
        
        let booksResponse = try await booksClient.getBooks(with: booksRequest)
        print(booksResponse)
    }
}
