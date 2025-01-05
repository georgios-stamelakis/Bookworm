//
//  BooksClient.swift
//  Bookworm
//
//  Created by Georgios Stamelakis on 4/1/25.
//

import Foundation

class BooksClient: APIClient {
    let session: URLSession

    init() {
        self.session = URLSession(configuration: .default)
    }

    func fetchBooks(with endpoint: BooksRequest) async throws -> BooksResponse {
        guard let request = endpoint.request else {
            throw APIError.requestFailed(description: "Unable to construct a valid request!")
        }

        let response = try await fetch(with: request, decodingType: [Book].self)

        let booksResponse = BooksResponse.init(books: response)
        return booksResponse
    }

}
