//
//  NameDTO.swift
//  ContactsApp
//
//  Created by Stanislav KUTSENKO on 01/04/2025.
//

import Foundation

struct NameDTO: Decodable {
	let title: String?
	let firstName: String
	let lastName: String
	
	private enum CodingKeys: String, CodingKey {
		case title
		case firstName = "first"
		case lastName = "last"
	}
}
