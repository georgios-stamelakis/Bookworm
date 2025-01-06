//
//  Book.swift
//  Bookworm
//
//  Created by Georgios Stamelakis on 5/1/25.
//

import Foundation

struct Book: Identifiable {
    let id: Int
    let title: String
    let imgUrl: String
    let dateReleased: Date
    let pdfUrl: String

    var state: DownloadState = .idle
    private(set) var currentBytes: Int64 = 0
    private(set) var totalBytes: Int64 = 0

    enum DownloadState: Equatable {
        case idle
        case dowloading
        case completed
        case canceled(resumeData: Data)
    }

    var progress: Double {
        guard totalBytes > 0 else { return 0 }
        return Double(currentBytes) / Double(totalBytes)
    }

    var isDownloadCompleted: Bool {
        currentBytes == totalBytes && totalBytes > 0
    }

    func getReleasedYear() -> Int {
        return Calendar.current.component(.year, from: dateReleased)
    }

    func getFileURL() -> URL {
            URL.documentsDirectory
                .appending(path: "\(id)")
                .appendingPathExtension("pdf")
    }

    mutating func update(currentBytes: Int64, totalBytes: Int64) {
        self.currentBytes = currentBytes
        self.totalBytes = totalBytes
    }
}

extension Book: Decodable {
    private enum CodingKeys: String, CodingKey {
        case id = "id"
        case title = "title"
        case imgUrl = "img_url"
        case dateReleased = "date_released"
        case pdfUrl = "pdf_url"
    }
}
