//
//  ListStateView.swift
//  ContactsApp
//
//  Created by Stanislav KUTSENKO on 01/04/2025.
//

import UIKit

final class ListStateView: UIView {
	
	var state: State? {
		didSet {
			configure()
		}
	}
	
	private let titleLabel = UILabel()
	private let imageView = UIImageView()
	private let actionButton = UIButton(type: .system)
	
	// MARK: - Lifecycle
	override init(frame: CGRect) {
		super.init(frame: frame)
		setupUI()
	}
	
	required init?(coder: NSCoder) {
		super.init(coder: coder)
		setupUI()
	}
}

// MARK: - Private
private extension ListStateView {
	func setupUI() {
		[imageView, titleLabel, actionButton].forEach { view in
			view.translatesAutoresizingMaskIntoConstraints = false
			addSubview(view)
		}
		
		NSLayoutConstraint.activate([
			imageView.heightAnchor.constraint(equalToConstant: 60),
			imageView.widthAnchor.constraint(equalToConstant: 60),
			imageView.centerXAnchor.constraint(equalTo: centerXAnchor),
			imageView.bottomAnchor.constraint(equalTo: titleLabel.topAnchor, constant: -Padding.medium),
			
			titleLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
			titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Padding.medium),
			titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -Padding.medium),
			titleLabel.heightAnchor.constraint(equalToConstant: 32),
			
			actionButton.heightAnchor.constraint(equalToConstant: 32),
			actionButton.widthAnchor.constraint(equalToConstant: 80),
			actionButton.centerXAnchor.constraint(equalTo: centerXAnchor),
			actionButton.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: Padding.medium)
		])
		
		imageView.contentMode = .scaleAspectFit
		titleLabel.numberOfLines = 2
		titleLabel.textAlignment = .center
		titleLabel.textColor = .white
		titleLabel.font = .systemFont(ofSize: 16)
		actionButton.setTitleColor(.systemBlue, for: .normal)
		actionButton.addTarget(self, action: #selector(onAction), for: .touchUpInside)
	}
	
	func configure() {
		guard let state else { return erase() }
		titleLabel.text = state.title
		imageView.image = state.image
		
		if let action = state.action {
			actionButton.setTitle(action.title, for: .normal)
			actionButton.isHidden = false
		} else {
			actionButton.isHidden = true
		}
	}
	
	func erase() {
		titleLabel.text = nil
		imageView.image = nil
	}
	
	@objc
	func onAction() {
		state?.action?.onAction()
	}
}

// MARK: - State Object
extension ListStateView {
	struct State {
		let title: String
		let action: Action?
		let image: UIImage?
	}
	
	struct Action {
		let title: String
		let onAction: (() -> Void)
	}
}
