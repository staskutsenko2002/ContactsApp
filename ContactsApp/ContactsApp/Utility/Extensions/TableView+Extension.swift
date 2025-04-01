//
//  TableView+Extension.swift
//  ContactsApp
//
//  Created by Stanislav KUTSENKO on 01/04/2025.
//

import UIKit

protocol Reusable {
	static var reuseIdentifier: String { get }
}

extension Reusable {
	static var reuseIdentifier: String {
		String(describing: Self.self)
	}
}

extension UITableView {
	// MARK: - UITableViewCell
	func register<T: UITableViewCell>(_: T.Type) where T: Reusable {
		register(T.self, forCellReuseIdentifier: T.reuseIdentifier)
	}

	func dequeue<T: UITableViewCell>(_: T.Type, for indexPath: IndexPath) -> T? where T: Reusable {
		dequeueReusableCell(withIdentifier: T.reuseIdentifier, for: indexPath) as? T
	}
}
