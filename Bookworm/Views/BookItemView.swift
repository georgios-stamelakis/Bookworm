//
//  BookItemView.swift
//  Bookworm
//
//  Created by Georgios Stamelakis on 5/1/25.
//

import SwiftUI

struct BookItemView: View {
    let book: Book
    let onImageTapped: () -> Void

    var body: some View {
        VStack {
            ZStack {
                Button(action: onImageTapped) {

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

                    if book.state == .completed {
                        Image(systemName: "checkmark.circle.fill")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 40, height: 40)
                            .foregroundColor(.green)
                            .shadow(radius: 2)

                }
            }

            if book.progress > 0 && !book.isDownloadCompleted {
                ProgressView(value: book.progress)
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
