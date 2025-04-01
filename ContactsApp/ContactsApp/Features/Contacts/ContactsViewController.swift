//
//  ContactsViewController.swift
//  ContactsApp
//
//  Created by Stanislav KUTSENKO on 01/04/2025.
//

import UIKit
import Combine

final class ContactsViewController: UIViewController {
	// MARK: - Private properties
	private let viewModel: ContactsViewModel
	private var cancellables = Set<AnyCancellable>()
	
	// MARK: - UI
	private lazy var tableView: UITableView = {
		let tableView = UITableView()
		tableView.translatesAutoresizingMaskIntoConstraints = false
		tableView.separatorColor = .lightGray
		tableView.register(ContactListCell.self)
		tableView.refreshControl = tableRefreshControl
		return tableView
	}()
	
	private lazy var tableRefreshControl: UIRefreshControl = {
		let refreshControl = UIRefreshControl()
		refreshControl.tintColor = .lightGray
		refreshControl.addTarget(self, action: #selector(didPullToRefresh), for: .valueChanged)
		return refreshControl
	}()
	
	// MARK: - Life cycle
	init(viewModel: ContactsViewModel) {
		self.viewModel = viewModel
		super.init(nibName: nil, bundle: nil)
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		setupUI()
		setupLayout()
		setupSubscription()
	}
}

// MARK: - Private methods
private extension ContactsViewController {
	func setupSubscription() {
		viewModel.$state.sink { [weak self] state in
			guard let self else { return }
			DispatchQueue.main.async {
				self.reloadData()
				
				switch state {
				case .loading:
					self.hideStateView()
					
				case .empty:
					self.reloadData()
					self.tableRefreshControl.endRefreshing()
					self.showEmptyState()
					
				case .error(let message):
					self.reloadData()
					self.tableRefreshControl.endRefreshing()
					self.showErrorState(title: message)
					
				case .loaded:
					self.reloadData()
					self.tableRefreshControl.endRefreshing()
					self.hideStateView()
				}
			}
		}
		.store(in: &cancellables)
	}
	
	func setupUI() {
		view.backgroundColor = .black
		navigationItem.title = "Contacts"
		navigationItem.largeTitleDisplayMode = .never
		
		tableView.delegate = self
		tableView.dataSource = self
		tableView.backgroundColor = .black
	}
	
	func setupLayout() {
		view.addSubview(tableView)
		NSLayoutConstraint.activate([
			tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
			tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
			tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
			tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
		])
	}
	
	func reloadData() {
		tableView.reloadData()
	}
}

// MARK: - State view methods
private extension ContactsViewController {
	
	func showStateView(title: String, image: UIImage?, action: ListStateView.Action? = nil) {
		let stateView = ListStateView()
		stateView.state = .init(title: title, action: action, image: image)
		tableView.backgroundView = stateView
	}
	
	func showEmptyState() {
		showStateView(title: "No contacts found", image: Images.search, action: .init(title: "Refresh", onAction: { [weak self] in
			self?.viewModel.fetchContacts(isRefresh: true)
		}))
	}
	
	func showErrorState(title: String) {
		showStateView(title: title, image: Images.warning, action: .init(title: "Refresh", onAction: { [weak self] in
			self?.viewModel.fetchContacts(isRefresh: true)
		}))
	}
	
	func hideStateView() {
		tableView.backgroundView = nil
	}
}

// MARK: - Selectors
@objc private extension ContactsViewController {
	func didPullToRefresh() {
		viewModel.fetchContacts(isRefresh: true)
	}
}

// MARK: - UITableViewDelegate, UITableViewDataSource
extension ContactsViewController: UITableViewDelegate, UITableViewDataSource {

	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		guard case let .loaded(contacts) = viewModel.state else { return 0 }

		return contacts.count
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		guard case let .loaded(contacts) = viewModel.state,
			  let cell = tableView.dequeue(ContactListCell.self, for: indexPath) else { return UITableViewCell() }

		let contact = contacts[indexPath.row]
		let fullName = "\(contact.name.firstName) \(contact.name.lastName)"
		cell.setup(name: fullName, imageUrl: contact.picture?.thumbnail)
		return cell
	}
	
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		viewModel.openDetails(at: indexPath.row)
	}
	
	func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
		return ContactListCell.height
	}
	
	func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
		guard
			case let .loaded(contacts) = viewModel.state,
			indexPath.row >= contacts.count - 3
		else { return }

		viewModel.fetchContacts()
	}
}
