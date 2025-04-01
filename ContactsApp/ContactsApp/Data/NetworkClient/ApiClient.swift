//
//  ApiClient.swift
//  ContactsApp
//
//  Created by Stanislav KUTSENKO on 01/04/2025.
//

import Foundation

final class ApiClient: NetworkClient {
	private let session = URLSession.shared

	func get<Response: Decodable>(urlString: String, params: [String: String]) async throws -> Response {
		var urlComponents = URLComponents(string: urlString)
		urlComponents?.queryItems = params.map({ URLQueryItem(name: $0, value: $1) })
		
		guard let url = urlComponents?.url else {
			throw ApiError.invalidURL
		}
		
		var request = URLRequest(url: url)
		request.httpMethod = HttpMethod.get.rawValue
		let response: Response = try await requestDecodable(request)
		return response
	}

	private func requestDecodable<Response: Decodable>(_ urlRequest: URLRequest) async throws -> Response {
		let (data, _) = try await session.data(for: urlRequest)
		return try JSONDecoder().decode(Response.self, from: data)
	}
}
