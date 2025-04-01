//
//  ContactsViewModel.swift
//  ContactsApp
//
//  Created by Stanislav KUTSENKO on 01/04/2025.
//

import Foundation
import Combine

enum ContactsState {
	case loading
	case empty
	case error(message: String)
	case loaded([Contact])
}

final class ContactsViewModel {
	// MARK: - Private Properties
	private let contactsUseCase: GetContactsUseCase
	private let onAction: (ContactsCoordinator.Action) -> Void
	@Published var state: ContactsState = .loading
	private var contacts: [Contact] = []
	
	// MARK: - init
	init(contactsUseCase: GetContactsUseCase, onAction: @escaping (ContactsCoordinator.Action) -> Void) {
		self.contactsUseCase = contactsUseCase
		self.onAction = onAction
		fetchContacts()
	}
	
	// MARK: - Methods
	func fetchContacts(isRefresh: Bool = false) {
		Task.init {
			do {
				let contacts = try await contactsUseCase.execute(count: 10)
				
				if isRefresh {
					self.contacts = contacts
				} else {
					self.contacts += contacts
				}
				state = self.contacts.isEmpty ? .empty : .loaded(self.contacts)
			} catch _ as URLError {
				state = .error(message: "Connection problem. Please, try again later")
			} catch {
				state = .error(message: error.localizedDescription)
			}
		}
	}
	
	func openDetails(at index: Int) {
		onAction(.openDetails(contacts[index]))
	}
}
