//
//  AppCoordinator.swift
//  ContactsApp
//
//  Created by Stanislav KUTSENKO on 01/04/2025.
//

import UIKit

final class AppCoordinator {
	private var window: UIWindow
	private var contactsCoordinator: ContactsCoordinator

	init(window: UIWindow) {
		self.window = window
		self.contactsCoordinator = ContactsCoordinator()
	}
	
	func start() {
		window.makeKeyAndVisible()
		window.rootViewController = contactsCoordinator.start()
	}
}
