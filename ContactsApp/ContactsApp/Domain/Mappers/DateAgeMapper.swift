//
//  DateAgeMapper.swift
//  ContactsApp
//
//  Created by Stanislav KUTSENKO on 01/04/2025.
//

import Foundation

final class DateAgeMapper: Mapper {
	private let formatter = ISO8601DateFormatter()
	
	func map(input: DateAgeDTO) -> DateAge {
		return DateAge(
			date: formatter.date(from: input.date),
			age: input.age
		)
	}
}
