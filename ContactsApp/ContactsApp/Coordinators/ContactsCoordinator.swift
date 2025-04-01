//
//  ContactsCoordinator.swift
//  ContactsApp
//
//  Created by Stanislav KUTSENKO on 01/04/2025.
//

import UIKit
import MessageUI

final class ContactsCoordinator: NSObject {
	
	enum Action {
		case openDetails(Contact)
	}
	
	private lazy var navigationController = makeNavigationController()
	
	func start() -> UIViewController {
		navigationController
	}
	
	private func makeNavigationController() -> UINavigationController {
		let navigationController = UINavigationController(rootViewController: makeContactsViewController())
		navigationController.title = "Contacts"
		navigationController.navigationBar.backgroundColor = .black
		navigationController.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.white]
		return navigationController
	}
	
	private func makeContactsViewController() -> UIViewController {
		let apiClient: NetworkClient = ApiClient()
		let repository: ContactsRepository = ContactsRepositoryImpl(networkClient: apiClient)
		let useCase = GetContactsUseCase(repository: repository)
		let viewModel = ContactsViewModel(contactsUseCase: useCase) { [weak self] action in
			self?.handleAction(action: action)
		}
		let viewController = ContactsViewController(viewModel: viewModel)
		return viewController
	}
	
	private func makeDetailsViewController(contact: Contact) -> UIViewController {
		let viewModel = ContactDetailsViewModel(contact: contact, onAction: { [weak self] action in
			guard let self else { return }
			switch action {
			case .phone(let phone):
				self.openPhone(phone: phone)
			case .email(let email):
				self.openMail(email: email)
			case .map(let coordinates):
				self.openMap(coordinates: coordinates)
			}
		})
		let viewController = ContactDetailsViewController(viewModel: viewModel)
		return viewController
	}
	
	private func handleAction(action: Action) {
		switch action {
		case .openDetails(let contact):
			let detailsViewController = makeDetailsViewController(contact: contact)
			navigationController.pushViewController(detailsViewController, animated: true)
		}
	}
	
	private func openPhone(phone: String) {
		if let url = URL(string: "tel://\(phone)"), UIApplication.shared.canOpenURL(url) {
			UIApplication.shared.open(url)
		}
	}
	
	private func openMail(email: String) {
		guard MFMailComposeViewController.canSendMail() else { return }
			
		let mailComposeViewController = MFMailComposeViewController()
		mailComposeViewController.mailComposeDelegate = self
		mailComposeViewController.setToRecipients([email])
		navigationController.present(mailComposeViewController, animated: true)
	}
	
	private func openMap(coordinates: Coordinates?) {
		guard let coordinates else { return }

		if let url = URL(string: "http://maps.apple.com/?q=\(coordinates.latitude),\(coordinates.longitude)") {
			UIApplication.shared.open(url)
		}
	}
}

// MARK: - MFMailComposeViewControllerDelegate
extension ContactsCoordinator: MFMailComposeViewControllerDelegate {

	func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: (any Error)?) {
		controller.dismiss(animated: true)
	}
}
