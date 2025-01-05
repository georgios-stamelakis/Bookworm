//
//  BooksResponse.swift
//  Bookworm
//
//  Created by Georgios Stamelakis on 4/1/25.
//

import Foundation

/*
sample Books Response

 let json = """
 [
     {
         "id": 1,
         "title": "Physician, The",
         "img_url": "http://dummyimage.com/250x250.png/5fa2dd/ffffff",
         "date_released": "2020-07-23T00:42:35Z",
         "pdf_url": "https://www.learningcontainer.com/wp-content/uploads/2019/09/sample-pdf-download-10-mb.pdf"
     },
     {
         "id": 2,
         "title": "Bakeneko: A Vengeful Spirit (Kaiby� nori no numa) (Ghost-Cat Cursed Pond, The)",
         "img_url": "http://dummyimage.com/250x250.png/ff4444/ffffff",
         "date_released": "2020-01-15T09:16:36Z",
         "pdf_url": "https://www.learningcontainer.com/wp-content/uploads/2019/09/sample-pdf-with-images.pdf"
     },
     {
         "id": 3,
         "title": "Teeth",
         "img_url": "http://dummyimage.com/250x250.png/ff4444/ffffff",
         "date_released": "2020-11-02T05:34:20Z",
         "pdf_url": "https://www.hq.nasa.gov/alsj/a17/A17_FlightPlan.pdf"
     }
 ]
 """

 */

struct BooksResponse: Decodable {
    let books: [Book]
}

struct Book: Decodable, Identifiable {
    let id: Int
    let title: String
    let imgUrl: String
    let dateReleased: Date
    let pdfUrl: String

    private enum CodingKeys: String, CodingKey {
        case id = "id"
        case title = "title"
        case imgUrl = "img_url"
        case dateReleased = "date_released"
        case pdfUrl = "pdf_url"
    }
}
