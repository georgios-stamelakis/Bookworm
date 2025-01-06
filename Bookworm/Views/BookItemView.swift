//
//  BookItemView.swift
//  Bookworm
//
//  Created by Georgios Stamelakis on 5/1/25.
//

import SwiftUI
import QuickLook

struct BookItemView: View {
    let book: Book
    let onImageTapped: () -> Void

    @State var pdfURL: URL?


    var body: some View {
        VStack {
            ZStack {
                Button(action: {
                    if book.state == .completed {
                        pdfURL = book.getFileURL()
                    } else {
                        onImageTapped()
                    }
                }) {
                    AsyncImage(url: URL(string: book.imgUrl)) { phase in
                        switch phase {
                        case .empty:
                            ProgressView()
                                .frame(width: 150, height: 200)
                        case .success(let image):
                            image
                                .resizable()
                                .scaledToFill()
                                .frame(width: 150, height: 200)
                                .clipped()
                                .cornerRadius(10)
                        case .failure:
                            Image(systemName: "photo")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 150, height: 200)
                                .foregroundColor(.gray)
                        @unknown default:
                            EmptyView()
                        }
                    }
                }
                .quickLookPreview($pdfURL)

                if book.state == .completed {
                    TriangleBadge()
                        .fill(Color.green)
                        .frame(width: 150, height: 200)
                        .cornerRadius(10)
                        .overlay(alignment: .bottomTrailing) {
                                Image(systemName: "checkmark")
                                    .foregroundColor(.white)
                                    .font(.system(size: 16, weight: .bold))
                                    .offset(x: -7, y: -7)
                        }
                }

            }

            if book.progress > 0 && !book.isDownloadCompleted {
                ProgressView(value: book.progress)
                    .frame(width: 150)
            }

            Text(book.title)
                .font(.caption)
                .lineLimit(2)
                .multilineTextAlignment(.center)
                .frame(width: 150)

            Spacer()
        }
    }
}

struct TriangleBadge: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.move(to: CGPoint(x: rect.maxX, y: rect.maxY/1.35))
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY))
        path.addLine(to: CGPoint(x: rect.maxX/1.5, y: rect.maxY))
        path.closeSubpath()
        return path
    }
}
