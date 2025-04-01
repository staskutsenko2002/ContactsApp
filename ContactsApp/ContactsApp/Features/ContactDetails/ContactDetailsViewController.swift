//
//  ContactDetailsViewController.swift
//  ContactsApp
//
//  Created by Stanislav KUTSENKO on 01/04/2025.
//

import UIKit

final class ContactDetailsViewController: UIViewController {
	// MARK: - Private properties
	private let viewModel: ContactDetailsViewModel
	
	// MARK: - UI
	private var tableView: UITableView = {
		let tableView = UITableView()
		tableView.translatesAutoresizingMaskIntoConstraints = false
		tableView.backgroundColor = .clear
		tableView.separatorStyle = .none
		tableView.register(AvatarNameCell.self)
		tableView.register(ContactInfoCell.self)
		tableView.register(LocationCell.self)
		return tableView
	}()
	
	// MARK: - Life cycle
	init(viewModel: ContactDetailsViewModel) {
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
		tableView.reloadData()
	}
}

// MARK: - Private methods
private extension ContactDetailsViewController {
	func setupUI() {
		view.backgroundColor = .black
		navigationItem.title = "Details"
		navigationItem.largeTitleDisplayMode = .never
		tableView.delegate = self
		tableView.dataSource = self
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
}

// MARK: - UITableViewDelegate, UITableViewDataSource
extension ContactDetailsViewController: UITableViewDelegate, UITableViewDataSource {
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return 1
	}
	
	func numberOfSections(in tableView: UITableView) -> Int {
		return viewModel.cellTypes.count
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		return cell(viewModel.cellTypes[indexPath.section], indexPath: indexPath)
	}
	
	func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
		UITableView.automaticDimension
	}
	
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		viewModel.handleAction(at: indexPath)
	}
	
	func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
		viewModel.cellTypes[section] == .avatarName ? 0 : 20
	}
	
	func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
		let type = viewModel.cellTypes[section]
		
		if type == .avatarName {
			return nil
		}
		
		let header = UIView()
		header.backgroundColor = .black
		header.translatesAutoresizingMaskIntoConstraints = false
		return header
	}
}

// MARK: - Cell method
private extension ContactDetailsViewController {

	func cell(_ type: ContactCellType, indexPath: IndexPath) -> UITableViewCell {
		switch type {
		case .avatarName:
			guard let cell = tableView.dequeue(AvatarNameCell.self, for: indexPath) else { return UITableViewCell() }
			cell.setup(with: viewModel.contact)
			return cell

		case .phone, .cellPhone, .email, .birthday, .gender, .nationality:
			guard let cell = tableView.dequeue(ContactInfoCell.self, for: indexPath) else { return UITableViewCell() }
			let type = viewModel.cellTypes[indexPath.section]
			cell.setup(with: viewModel.contact, type: type)
			return cell

		case .location:
			guard let cell = tableView.dequeue(LocationCell.self, for: indexPath) else { return UITableViewCell() }
			cell.setup(with: viewModel.contact)
			return cell
		}
	}
}
