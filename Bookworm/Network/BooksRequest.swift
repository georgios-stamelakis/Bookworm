//
//  BooksRequest.swift
//  Bookworm
//
//  Created by Georgios Stamelakis on 4/1/25.
//

import Foundation

struct BooksRequest: Endpoint {

    var needsAuthorization = true

    var httpMethod: HTTPMethod {
        .get
    }

    var path: String {
        "/Access/Books"
    }
}
