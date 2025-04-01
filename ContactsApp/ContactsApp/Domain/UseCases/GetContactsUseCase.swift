//
//  GetContactsUseCase.swift
//  ContactsApp
//
//  Created by Stanislav KUTSENKO on 01/04/2025.
//

import Foundation

final class GetContactsUseCase {
	
	private let repository: ContactsRepository
	
	init(repository: ContactsRepository) {
		self.repository = repository
	}
	
	func execute(count: Int) async throws -> [Contact] {
		return try await repository.getContacts(count: count)
	}
}
