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

    @Published var isPresentingError: Bool = false
    @Published var errorMessage: String = ""

    @Published var groupedBooks: [Int: [Int : Book]] = [:]
    private var downloads: [URL: Download] = [:]

    private let booksRepository: BooksRepository

    init(booksRepository: BooksRepository = DefaultBooksRepository()) {
        self.booksRepository = booksRepository
    }

    func getBooks() {
        isLoading = true

        Task {
            defer { isLoading = false }

            do {
                let books = try await booksRepository.fetchBooks()
                groupedBooks = groupBooksByYear(books: books)
            } catch let error as APIError {
                triggerError(withDescription: error.userReadableDescription)
            } catch {
                triggerError(withDescription: "Unknown error occurred.")
            }
        }
    }

    private func groupBooksByYear(books: [Book]) -> [Int: [Int: Book]] {
        var result: [Int: [Int: Book]] = [:]
        for book in books {
            let updatedBook = getBookWithDownloadState(from: book)
            let year = book.getReleasedYear()
            result[year, default: [:] ][book.id] = updatedBook
        }
        return result
    }

    // MARK: Download pdf methods
    func download(_ book: Book) {
        guard let bookURL = URL(string: book.pdfUrl) else { return }
        guard downloads[bookURL] == nil, !book.isDownloadCompleted, book.state != .completed else { return }

        let download = Download(url: bookURL)
        downloads[bookURL] = download
        download.start()

        groupedBooks[book.getReleasedYear(), default: [:]][book.id]?.state = .dowloading

        Task {
            for await event in download.events {
                process(event, for: book)
            }
            downloads[bookURL] = nil
        }
    }

    func getBookWithDownloadState(from book: Book) -> Book {
        if FileManager.default.fileExists(atPath: book.getFileURL().path) {
            var newBook = book
            newBook.state = .completed
            return newBook
        }
        return book
    }

    private func triggerError(withDescription errorDescription: String) {
        errorMessage = errorDescription
        isPresentingError = true
    }

}

private extension BooksViewModel {
    func process(_ event: Download.Event, for book: Book) {
        switch event {
        case let .progress(current, total):
            groupedBooks[book.getReleasedYear(), default: [:]][book.id]?.update(currentBytes: current, totalBytes: total)
        case let .completed(url):
            saveFile(for: book, at: url)
            groupedBooks[book.getReleasedYear(), default: [:]][book.id]?.state = .completed
        case let .failed(error):
            triggerError(withDescription: error)
        case let .canceled(data):
            groupedBooks[book.getReleasedYear(), default: [:]][book.id]?.state = if let data {
                .canceled(resumeData: data)
            } else {
                .idle
            }
        }
    }

    func saveFile(for book: Book, at url: URL) {
        let documentsDirectory = URL.documentsDirectory
        let destinationURL = documentsDirectory.appendingPathComponent(book.getFileURL().lastPathComponent)

        let fileManager = FileManager.default
        do {
            try fileManager.moveItem(at: url, to: destinationURL)
        } catch {
            DebugLogger.log("Error saving file: \(error.localizedDescription)")
        }
    }

}
