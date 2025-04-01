//
//  ContactDetailsViewModel.swift
//  ContactsApp
//
//  Created by Stanislav KUTSENKO on 01/04/2025.
//

import Foundation

enum ContactCellType {
	case avatarName
	case phone
	case cellPhone
	case email
	case location
	case birthday
	case gender
	case nationality
}

enum ContactAction {
	case phone(String)
	case email(String)
	case map(Coordinates)
}

final class ContactDetailsViewModel {
	// MARK: - Private properties
	let contact: Contact
	var cellTypes: [ContactCellType] = []
	private let onAction: (ContactAction) -> Void
	
	// MARK: - Init
	init(contact: Contact, onAction: @escaping (ContactAction) -> Void) {
		self.contact = contact
		self.onAction = onAction
		setupInformation()
	}
	
	func setupInformation() {
		cellTypes.append(.avatarName)
		
		if contact.cellPhone.isNotEmpty {
			cellTypes.append(.cellPhone)
		}
		
		if !(contact.phone ?? "").isEmpty {
			cellTypes.append(.phone)
		}
		
		if !(contact.email ?? "").isEmpty {
			cellTypes.append(.email)
		}
		
		if contact.dateOfBirth.date != nil {
			cellTypes.append(.birthday)
		}
		
		if contact.location != nil {
			cellTypes.append(.location)
		}
		
		if !contact.gender.isEmpty {
			cellTypes.append(.gender)
		}
		
		if !(contact.nationality ?? "").isEmpty {
			cellTypes.append(.nationality)
		}
	}
	
	func handleAction(at indexPath: IndexPath) {
		let type = cellTypes[indexPath.section]
		
		switch type {
		case .cellPhone:
			if let cellPhone = contact.cellPhone {
				onAction(.phone(cellPhone))
			}
			
		case .phone:
			if let phone = contact.phone {
				onAction(.phone(phone))
			}
		case .email:
			if let email = contact.email {
				onAction(.email(email))
			}
			
		case .location:
			if let coordinates = contact.location?.coordinates {
				onAction(.map(coordinates))
			}

		case .avatarName, .birthday, .gender, .nationality:
			break
		}
	}
}

extension Optional where Wrapped == String {

	var isNotEmpty: Bool {
		if let self, self.isEmpty {
			true
		} else {
			false
		}
	}
}
