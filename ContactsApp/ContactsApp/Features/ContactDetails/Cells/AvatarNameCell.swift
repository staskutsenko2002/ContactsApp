//
//  AvatarNameCell.swift
//  ContactsApp
//
//  Created by Stanislav KUTSENKO on 01/04/2025.
//

import UIKit

final class AvatarNameCell: UITableViewCell, Reusable {
	// MARK: - UI
	private let avatarView: UIImageView = {
		let imageView = UIImageView()
		imageView.translatesAutoresizingMaskIntoConstraints = false
		imageView.contentMode = .scaleToFill
		imageView.layer.cornerRadius = 50
		imageView.layer.masksToBounds = true
		return imageView
	}()
	
	private let nameLabel: UILabel = {
		let label = UILabel()
		label.translatesAutoresizingMaskIntoConstraints = false
		label.font = .systemFont(ofSize: 24, weight: .bold)
		label.textColor = .white
		label.numberOfLines = 0
		label.textAlignment = .center
		return label
	}()
	
	// MARK: - Init
	override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
		super.init(style: style, reuseIdentifier: reuseIdentifier)
		setupUI()
		setupLayout()
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	// MARK: - Setup method
	func setup(with contact: Contact) {
		var name = ""
		if let title = contact.name.title {
			name = "\(title) "
		}
		
		if contact.name.firstName.isNotEmpty {
			name += "\(contact.name.firstName) "
		}
		
		if contact.name.lastName.isNotEmpty {
			name += "\(contact.name.lastName)"
		}
		
		nameLabel.text = name.isEmpty ? "Unknown" : name
		
		if let imageUrl = contact.picture?.thumbnail {
			avatarView.sd_setImage(with: imageUrl, placeholderImage: Images.userPlaceholder)
		} else {
			avatarView.image = Images.userPlaceholder
		}
	}
}

// MARK: - Private methods
private extension AvatarNameCell {
	func setupUI() {
		backgroundColor = .background
		selectionStyle = .none
		layer.cornerRadius = 10
		layer.masksToBounds = true
	}
	
	func setupLayout() {
		contentView.addSubview(avatarView)
		contentView.addSubview(nameLabel)
		
		NSLayoutConstraint.activate([
			avatarView.heightAnchor.constraint(equalToConstant: 100),
			avatarView.widthAnchor.constraint(equalToConstant: 100),
			avatarView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: Padding.medium),
			avatarView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
			
			nameLabel.topAnchor.constraint(equalTo: avatarView.bottomAnchor, constant: Padding.medium),
			nameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: Padding.medium),
			nameLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -Padding.medium),
			nameLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -Padding.medium)
		])
	}
}
