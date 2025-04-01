//
//  NameMapper.swift
//  ContactsApp
//
//  Created by Stanislav KUTSENKO on 01/04/2025.
//

import Foundation

final class NameMapper: Mapper {
	func map(input: NameDTO) -> Name {
		return Name(title: input.title, firstName: input.firstName, lastName: input.lastName)
	}
}
