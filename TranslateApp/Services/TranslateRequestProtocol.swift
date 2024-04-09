//
//  TranslateRequest.swift
//  TranslateApp
//
//  Created by Polina on 09.04.2024.
//

import Foundation

enum HTTPMethod: String {
    case get = "GET"
}

protocol TranslateRequestProtocol {
    associatedtype Response

    var url: String { get }
    var method: HTTPMethod { get }
    var headers: [String : String]? { get }
    var queryItems: [(String, String)]? { get }
    func decode(_ data: Data) throws -> Response
}

extension TranslateRequestProtocol where Response: Decodable {
    func decode(_ data: Data) throws -> Response {
        let decoder = JSONDecoder()
        return try decoder.decode(Response.self, from: data)
    }
}
