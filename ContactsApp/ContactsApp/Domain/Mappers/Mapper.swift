//
//  Mapper.swift
//  ContactsApp
//
//  Created by Stanislav KUTSENKO on 01/04/2025.
//

import Foundation

protocol Mapper {
	associatedtype Input: Decodable
	associatedtype Output
	
	func map(input: Input) -> Output
}
