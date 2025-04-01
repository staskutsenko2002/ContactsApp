//
//  ContactMapper.swift
//  ContactsApp
//
//  Created by Stanislav KUTSENKO on 01/04/2025.
//

import Foundation

struct ContactMapper: Mapper {
	private let nameMapper = NameMapper()
	private let pictureMapper = PictureMapper()
	private let dateAgeMapper = DateAgeMapper()
	private let locationMapper = LocationMapper()
	
	func map(input: ContactDTO) -> Contact {
		return Contact(
			name: nameMapper.map(input: input.name),
			gender: input.gender,
			location: locationMapper.map(input: input.location),
			email: input.email,
			phone: input.phone,
			cellPhone: input.cellPhone,
			picture: pictureMapper.map(input: input.picture),
			nationality: input.nationality,
			dateOfBirth: dateAgeMapper.map(input: input.dateOfBirth)
		)
	}
}
