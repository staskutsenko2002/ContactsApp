//
//  ContactInfoCell.swift
//  ContactsApp
//
//  Created by Stanislav KUTSENKO on 01/04/2025.
//

import UIKit

final class ContactInfoCell: UITableViewCell, Reusable {
	// MARK: - UI
	private let iconImageView: UIImageView = {
		let imageView = UIImageView()
		imageView.translatesAutoresizingMaskIntoConstraints = false
		imageView.contentMode = .scaleAspectFit
		imageView.tintColor = .systemBlue
		return imageView
	}()
	
	private let titleLabel: UILabel = {
		let label = UILabel()
		label.translatesAutoresizingMaskIntoConstraints = false
		label.font = .systemFont(ofSize: 14)
		label.textColor = .white
		label.numberOfLines = 1
		return label
	}()
	
	private let valueLabel: UILabel = {
		let label = UILabel()
		label.translatesAutoresizingMaskIntoConstraints = false
		label.font = .systemFont(ofSize: 18)
		label.textColor = .systemBlue
		label.numberOfLines = 1
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
	func setup(with contact: Contact, type: ContactCellType) {
		var icon: UIImage? = nil
		var title: String = ""
		var value: String = ""
		
		switch type {
		case .avatarName:
			break
		case .phone:
			title = "Phone"
			value = contact.phone ?? ""
			icon = Images.phone
		case .cellPhone:
			title = "Cell phone"
			value = contact.cellPhone ?? ""
			icon = Images.phone
		case .email:
			title = "Email"
			value = contact.email ?? ""
			icon = Images.email
		case .location:
			break
		case .birthday:
			if let date = contact.dateOfBirth.date {
				title = "Birthday"
				let date = date.formatted(date: .complete, time: .omitted)
				let age = contact.dateOfBirth.age
				value = date + " (\(age) \(age > 1 ? "years" : "year"))"
				icon = Images.birthday
			}
		case .gender:
			title = "Gender"
			value = contact.gender.capitalized
			icon = Images.gender
		case .nationality:
			if let nationalityCode = contact.nationality {
				title = "Nationality"
				icon = Images.nationality
				
				if let nationality = Nationality(rawValue: nationalityCode) {
					value = nationalityCode + " " + nationality.flag
				} else {
					value = nationalityCode
				}
			}
		}
		
		iconImageView.image = icon
		titleLabel.text = title
		valueLabel.text = value
	}
}

// MARK: - Private methods
private extension ContactInfoCell {
	func setupUI() {
		backgroundColor = .background
		selectionStyle = .none
		layer.cornerRadius = 10
		layer.masksToBounds = true
	}
	
	func setupLayout() {
		contentView.addSubview(iconImageView)
		contentView.addSubview(titleLabel)
		contentView.addSubview(valueLabel)
		
		NSLayoutConstraint.activate([
			iconImageView.heightAnchor.constraint(equalToConstant: 24),
			iconImageView.widthAnchor.constraint(equalToConstant: 24),
			iconImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: Padding.small),
			iconImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
			
			titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: Padding.small),
			titleLabel.leadingAnchor.constraint(equalTo: iconImageView.trailingAnchor, constant: Padding.small),
			titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -Padding.small),
			
			valueLabel.leadingAnchor.constraint(equalTo: iconImageView.trailingAnchor, constant: Padding.small),
			valueLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -Padding.small),
			valueLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: Padding.xsmall),
			valueLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -Padding.xsmall)
		])
	}
}
