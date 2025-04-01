//
//  ContactsRepository.swift
//  ContactsApp
//
//  Created by Stanislav KUTSENKO on 01/04/2025.
//

import Foundation

protocol ContactsRepository {
	func getContacts(count: Int) async throws -> [Contact]
}

final class ContactsRepositoryImpl: ContactsRepository {
	// MARK: - Private properties
	private let networkClient: NetworkClient
	private let contactMapper = ContactMapper()
	private let localStorageManager = LocalStorageManager(modelName: "ContactsApp")
	private var isFirstLoad = true
	
	// MARK: - Init
	init(networkClient: NetworkClient) {
		self.networkClient = networkClient
	}
	
	// MARK: - Methods
	func getContacts(count: Int) async throws -> [Contact] {
		let urlString = "https://randomuser.me/api/"
		let headers: [String: String] = [
			"results": String(describing: count)
		]
		
		do {
			let response: GetContactsResponse = try await networkClient.get(urlString: urlString, params: headers)
			let contacts = response.results.map(contactMapper.map(input:))
			
			if isFirstLoad {
				isFirstLoad = false
				self.localStorageManager.deleteAll()
			}

			DispatchQueue.main.async {
				self.localStorageManager.syncContacts(contacts)
			}
			
			return contacts
		} catch let error as URLError {
			if let contacts = localStorageManager.fetchContacts(), contacts.isNotEmpty {
				return contacts
			}
			
			throw error
		} catch {
			throw error
		}
	}
}

struct GetContactsResponse: Decodable {
	let results: [ContactDTO]
}
