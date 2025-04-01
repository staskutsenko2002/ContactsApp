//
//  NetworkClient.swift
//  ContactsApp
//
//  Created by Stanislav KUTSENKO on 01/04/2025.
//

import Foundation

enum ApiError: Error {
	case invalidURL
}

enum HttpMethod: String {
	case get = "GET"
}

protocol NetworkClient {
	func get<Response: Decodable>(urlString: String, params: [String: String]) async throws -> Response
}
