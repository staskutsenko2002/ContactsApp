//
//  PictureMapper.swift
//  ContactsApp
//
//  Created by Stanislav KUTSENKO on 01/04/2025.
//

import Foundation

final class PictureMapper: Mapper {
	func map(input: PictureDTO?) -> Picture {
		
		var thumbnail: URL? = nil
		var large: URL? = nil
		
		if let thumbnailStringUrl = input?.thumbnail, let thumbnailUrl = URL(string: thumbnailStringUrl) {
			thumbnail = thumbnailUrl
		}
		
		if let largeStringUrl = input?.large, let largeUrl = URL(string: largeStringUrl) {
			large = largeUrl
		}
		
		return Picture(
			thumbnail: thumbnail,
			large: large
		)
	}
}
