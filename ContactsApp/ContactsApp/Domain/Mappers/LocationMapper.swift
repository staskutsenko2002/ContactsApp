//
//  LocationMapper.swift
//  ContactsApp
//
//  Created by Stanislav KUTSENKO on 01/04/2025.
//

import Foundation

final class LocationMapper: Mapper {
	
	func map(input: LocationDTO?) -> Location? {
		var address: String = ""
		var coordinates: Coordinates? = nil
		
		if let street = input?.street {
			address = "\(street.number) \(street.name)"
		}
		
		if let city = input?.city, city.isNotEmpty {
			address += " \(city)"
		}
		
		if let state = input?.state, state.isNotEmpty {
			address += " \(state)"
		}
		
		if let postcode = input?.postcode, postcode.isNotEmpty {
			address += " \(postcode)"
		}
		
		if let country = input?.country, country.isNotEmpty {
			address += " \(country)"
		}
		
		if let coordinatesDto = input?.coordinates {
			coordinates = Coordinates(latitude: coordinatesDto.latitude, longitude: coordinatesDto.longitude)
		}
		
		return Location(
			address: address,
			coordinates: coordinates
		)
	}
}
