//
//  Location.swift
//  ContactsApp
//
//  Created by Stanislav KUTSENKO on 01/04/2025.
//

import Foundation

struct Location {
	let address: String?
	let coordinates: Coordinates?
}

struct Coordinates {
	let latitude: String
	let longitude: String
}
