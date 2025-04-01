//
//  ContactDTO.swift
//  ContactsApp
//
//  Created by Stanislav KUTSENKO on 01/04/2025.
//

import Foundation

struct ContactDTO: Decodable {
	let name: NameDTO
	let gender: String
	let location: LocationDTO?
	let email: String?
	let phone: String?
	let cellPhone: String?
	let picture: PictureDTO?
	let nationality: String?
	let dateOfBirth: DateAgeDTO
	
	private enum CodingKeys: String, CodingKey {
		case name
		case gender
		case location
		case email
		case phone
		case cellPhone = "cell"
		case picture
		case nationality = "nat"
		case dateOfBirth = "dob"
	}
}
