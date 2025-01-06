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

    @Published var groupedBooks: [Int: [Int : Book]] = [:]
    private var downloads: [URL: Download] = [:]

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

    private func groupBooksByYear(books: [Book]) -> [Int: [Int: Book]] {
        var result: [Int: [Int: Book]] = [:]
        for book in books {
            let year = book.getReleasedYear()
            result[year, default: [:] ][book.id] = book
        }
        return result
    }

    // MARK: Download pdf methods
    func download(_ book: Book) async throws {
        guard let bookURL = URL(string: book.pdfUrl) else { return }
        guard downloads[bookURL] == nil, !book.isDownloadCompleted else { return }

        let download = Download(url: bookURL)
        downloads[bookURL] = download
        download.start()

        groupedBooks[book.getReleasedYear(), default: [:]][book.id]?.state = .dowloading

        for await event in download.events {
            process(event, for: book)
        }

        downloads[bookURL] = nil
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
        case let .canceled(data):
            groupedBooks[book.getReleasedYear(), default: [:]][book.id]?.state = if let data {
                .canceled(resumeData: data)
            } else {
                .idle
            }
        }
    }

    func saveFile(for book: Book, at url: URL) {
        guard let fileURL = book.getFileURL() else { return }
        let documentsDirectory = URL.documentsDirectory
        let directoryURL = documentsDirectory.appendingPathComponent("books")
        let fileManager = FileManager.default
        if !fileManager.fileExists(atPath: directoryURL.path) {
            do {
                try fileManager.createDirectory(at: directoryURL, withIntermediateDirectories: true)
                print("Created 'books' directory at \(directoryURL.path)")
            } catch {
                print("Error creating directory: \(error.localizedDescription)")
                return
            }
        }

        let destinationURL = directoryURL.appendingPathComponent(fileURL.lastPathComponent)

        if fileManager.fileExists(atPath: destinationURL.path) {
            print("File already exists at \(destinationURL.path)")
            return
        }

        do {
            try fileManager.moveItem(at: url, to: destinationURL)
            print(destinationURL)
            print("File saved successfully at \(destinationURL.path)")
        } catch {
            print("Error saving file: \(error.localizedDescription)")
        }
    }

}
