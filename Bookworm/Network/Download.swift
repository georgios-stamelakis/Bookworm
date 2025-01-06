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
        case failed(error: String)
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

        guard let httpResponse = downloadTask.response as? HTTPURLResponse else {
            DebugLogger.log("Invalid HTTP Response")
            continuation.yield(.failed(error: "Download failed"))
            continuation.finish()
            return
        }

        let statusCode = httpResponse.statusCode
        DebugLogger.log("Status code is : \(statusCode)")
        guard (200...299).contains(statusCode) else {
            DebugLogger.log("Download failed with status code: \(statusCode)")
            continuation.yield(.failed(error: "Download failed - Server error"))
            continuation.yield(.canceled(data: nil))
            continuation.finish()
            return
        }

        guard let contentType = httpResponse.allHeaderFields["Content-Type"] as? String, contentType == "application/pdf" else {
            DebugLogger.log("Downloaded file is not a PDF, content type: \(String(describing: httpResponse.allHeaderFields["Content-Type"]))")
            continuation.yield(.failed(error: "Invalid file format"))
            continuation.yield(.canceled(data: nil))
            continuation.finish()
            return
        }

        let fileManager = FileManager.default
        guard let fileURL = getTemporaryFileURL() else {
            DebugLogger.log("Failed to get temporary file URL")
            continuation.yield(.failed(error: "Download failed"))
            continuation.yield(.canceled(data: nil))
            return
        }

        do {
            if fileManager.fileExists(atPath: fileURL.path) {
                DebugLogger.log("File already exists at \(fileURL.path)")
                return
            }
            try fileManager.moveItem(at: location, to: fileURL)
            DebugLogger.log("Successfully moved file to \(fileURL.path)")
        } catch {
            DebugLogger.log("Error moving file: \(error.localizedDescription)")
            continuation.yield(.failed(error: "Couldn't write file to disk"))
            continuation.yield(.canceled(data: nil))
            continuation.finish()
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

        func urlSession(_ session: URLSession, task: URLSessionTask, didCompleteWithError error: Error?) {
            if let error = error {
                DebugLogger.log("Download error: \(error.localizedDescription)")
                continuation.yield(.failed(error: "Download failed"))
                continuation.yield(.canceled(data: nil))
                continuation.finish()
            }
        }
}

