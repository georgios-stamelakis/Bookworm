//
//  LoginRequest.swift
//  Bookworm
//
//  Created by Georgios Stamelakis on 4/1/25.
//

import Foundation

struct LoginRequest: Endpoint {

    let username: String
    let password: String

    var httpMethod: HTTPMethod {
        .post
    }

    var path: String {
        "/Access/Login"
    }

    var postData: [String: Any]? {
        [
            "username": username,
            "password": password
        ]
    }
}
