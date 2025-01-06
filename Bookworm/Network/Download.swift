//
//  Download.swift
//  Bookworm
//
//  Created by Georgios Stamelakis on 5/1/25.
//

import Foundation

final class Download: NSObject {
    let events: AsyncStream<Event>
    private let continuation: AsyncStream<Event>.Continuation
    private let task: URLSessionDownloadTask

    enum Event {
        case progress(currentBytes: Int64, totalBytes: Int64)
        case completed(url: URL)
        case canceled(data: Data?)
    }

    convenience init(url: URL) {
        self.init(task: URLSession.shared.downloadTask(with: url))
    }

    convenience init(resumeData data: Data) {
        self.init(task: URLSession.shared.downloadTask(withResumeData: data))
    }

    private init(task: URLSessionDownloadTask) {
        self.task = task
        (self.events, self.continuation) = AsyncStream.makeStream(of: Event.self)
        super.init()
        continuation.onTermination = { @Sendable [weak self] _ in
            self?.cancel()
        }
    }

    func start() {
        task.delegate = self
        task.resume()
    }

    func cancel() {
        task.cancel { data in
            self.continuation.yield(.canceled(data: data))
            self.continuation.finish()
        }
    }

}

extension Download: URLSessionDownloadDelegate {
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didFinishDownloadingTo location: URL) {

        let fileManager = FileManager.default
        guard let fileURL = getTemporaryFileURL() else {
            print("Failed to get temporary file URL")
            return
        }

        do {
            if fileManager.fileExists(atPath: fileURL.path) {
                print("File already exists at \(fileURL.path)")
                return
            }
            try fileManager.moveItem(at: location, to: fileURL)
            print("Successfully moved file to \(fileURL.path)")
        } catch {
            print("Error moving file: \(error.localizedDescription)")
        }
        continuation.yield(.completed(url: fileURL))
        continuation.finish()
    }

    private func getTemporaryFileURL() -> URL? {
        let anID = UUID().uuidString
        let fileURL = URL(fileURLWithPath: NSTemporaryDirectory()).appendingPathComponent(anID)
        return fileURL
    }

    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didWriteData bytesWritten: Int64, totalBytesWritten: Int64, totalBytesExpectedToWrite: Int64) {
        continuation.yield(
            .progress(
                currentBytes: totalBytesWritten,
                totalBytes: totalBytesExpectedToWrite))
    }
}
