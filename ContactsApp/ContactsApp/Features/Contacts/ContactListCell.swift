//
//  ContactListCell.swift
//  ContactsApp
//
//  Created by Stanislav KUTSENKO on 01/04/2025.
//

import UIKit
import SDWebImage

final class ContactListCell: UITableViewCell, Reusable {
	// MARK: - Properties
	static var height: CGFloat {
		return Padding.normal + 40 + Padding.normal
	}
	
	// MARK: - UI
	private let avatarView: UIImageView = {
		let imageView = UIImageView()
		imageView.translatesAutoresizingMaskIntoConstraints = false
		imageView.contentMode = .scaleToFill
		imageView.layer.cornerRadius = 20
		imageView.layer.masksToBounds = true
		return imageView
	}()
	
	private let nameLabel: UILabel = {
		let label = UILabel()
		label.translatesAutoresizingMaskIntoConstraints = false
		label.font = .systemFont(ofSize: 16, weight: .semibold)
		label.textColor = .white
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
	
	func setup(name: String, imageUrl: URL?) {
		nameLabel.text = name
		
		if let imageUrl {
			avatarView.sd_setImage(with: imageUrl, placeholderImage: Images.userPlaceholder)
		} else {
			avatarView.image = Images.userPlaceholder
		}
	}
}

// MARK: - Setup methods
private extension ContactListCell {
	func setupUI() {
		backgroundColor = .clear
		contentView.backgroundColor = .clear
		selectionStyle = .none
	}
	
	func setupLayout() {
		contentView.addSubview(avatarView)
		contentView.addSubview(nameLabel)
		
		NSLayoutConstraint.activate([
			avatarView.heightAnchor.constraint(equalToConstant: 40),
			avatarView.widthAnchor.constraint(equalTo: avatarView.heightAnchor),
			avatarView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: Padding.medium),
			avatarView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: Padding.normal),
			avatarView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -Padding.normal),
			
			nameLabel.leadingAnchor.constraint(equalTo: avatarView.trailingAnchor, constant: Padding.medium),
			nameLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
			nameLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -Padding.medium),
		])
	}
}
