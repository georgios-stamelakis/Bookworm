//
//  Endpoint.swift
//  Bookworm
//
//  Created by Georgios Stamelakis on 4/1/25.
//

import Foundation

protocol Endpoint {
    var httpMethod: HTTPMethod { get }
    var path: String { get }
    var postData: [String: Any]? { get }
}

extension Endpoint {
    // Optional properties
    var postData: [String: Any]? { nil }

    private var serverURL: URL? {
        URL(string: "https://3nt-demo-backend.azurewebsites.net")
    }

    private var scheme: String? {
        serverURL?.scheme
    }

    private var host: String? {
        serverURL?.host
    }

    private var port: Int? {
        serverURL?.port
    }

    private var urlComponents: URLComponents {
        var components = URLComponents()
        components.scheme = scheme
        components.host = host
        components.path = path
        components.port = port

        return components
    }

    private func addHeaders(_ headers: [HTTPHeader], to request: inout URLRequest) {
        for headerItem in headers {
            request.addValue(headerItem.header.value, forHTTPHeaderField: headerItem.header.field)
        }
    }

    private var encodedBodyData: Data? {
        guard let postData = postData else { return nil }

        return try? JSONSerialization.data(withJSONObject: postData, options: [])
    }

    var request: URLRequest? {
        guard let url = urlComponents.url else { return nil }

        var request = URLRequest(url: url)

        request.httpMethod = httpMethod.rawValue

        // Set post data if they exist
        if let encodedData = encodedBodyData {
            request.httpBody = encodedData
            let headers = [HTTPHeader.contentLength(String(encodedData.count)), HTTPHeader.contentType("application/json; charset=utf-8")]
            addHeaders(headers, to: &request)
        }

#if DEBUG
        printRequestDetails(request)
#endif

        return request
    }

    func printRequestDetails(_ request: URLRequest) {
        print("URL: \(request.url?.absoluteString ?? "No URL")")
        print("HTTP Method: \(request.httpMethod ?? "No HTTP Method")")

        if let headers = request.allHTTPHeaderFields {
            print("Headers:")
            headers.forEach { key, value in
                print("\(key): \(value)")
            }
        }

        if let body = request.httpBody {
            if let bodyString = String(data: body, encoding: .utf8) {
                print("Body (as String): \(bodyString)")
            }
            if let jsonBody = try? JSONSerialization.jsonObject(with: body, options: .json5Allowed),
               let jsonData = try? JSONSerialization.data(withJSONObject: jsonBody, options: .prettyPrinted),
               let jsonString = String(data: jsonData, encoding: .utf8) {
                print("Body (as JSON): \(jsonString)")
            } else {
                print("Body (raw): \(body)")
            }
        } else {
            print("Body: No body")
        }
    }

}
