//
//  LocationDTO.swift
//  ContactsApp
//
//  Created by Stanislav KUTSENKO on 01/04/2025.
//

import Foundation

struct LocationDTO: Decodable {
	let street: StreetDTO?
	let city: String?
	let state: String?
	let country: String?
	let postcode: String?
	let coordinates: CoordinatesDTO?
	
	private enum CodingKeys: String, CodingKey {
		case street
		case city
		case state
		case country
		case postcode
		case coordinates
		case timezone
	}
	
	init(from decoder: Decoder) throws {
		let container = try decoder.container(keyedBy: CodingKeys.self)
		self.street = try container.decode(StreetDTO.self, forKey: .street)
		self.city = try container.decode(String.self, forKey: .city)
		self.state = try container.decode(String.self, forKey: .state)
		self.country = try container.decode(String.self, forKey: .country)
		self.coordinates = try container.decode(CoordinatesDTO.self, forKey: .coordinates)
		
		if let postcode = try? container.decode(String.self, forKey: .postcode) {
			self.postcode = postcode
		} else if let postcode = try? container.decode(Int.self, forKey: .postcode) {
			self.postcode = String(describing: postcode)
		} else {
			self.postcode = nil
		}
	}
}

struct StreetDTO: Decodable {
	let number: Int
	let name: String
}

struct CoordinatesDTO: Decodable {
	let latitude: String
	let longitude: String
}
