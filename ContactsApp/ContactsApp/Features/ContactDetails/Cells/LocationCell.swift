//
//  LocationCell.swift
//  ContactsApp
//
//  Created by Stanislav KUTSENKO on 01/04/2025.
//

import UIKit
import MapKit

final class LocationCell: UITableViewCell, Reusable {
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
		label.textColor = .white
		label.numberOfLines = 0
		label.contentMode = .topLeft
		return label
	}()
	
	private let mapView: MKMapView = {
		let mapView = MKMapView()
		mapView.translatesAutoresizingMaskIntoConstraints = false
		mapView.isUserInteractionEnabled = false
		mapView.layer.cornerRadius = 10
		return mapView
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
		titleLabel.text = "Address"
		
		if let address = contact.location?.address, address.isNotEmpty {
			valueLabel.text = address
		} else {
			valueLabel.text = "Unknown"
		}
		
		if let coordinates = contact.location?.coordinates {
			let latitude = Double(coordinates.latitude)
			let longitude = Double(coordinates.longitude)
			let coordinate = CLLocationCoordinate2D(latitude: latitude ?? 0, longitude: longitude ?? 0)
			let region = MKCoordinateRegion(center: coordinate, latitudinalMeters: 500, longitudinalMeters: 500)
			mapView.setRegion(region, animated: true)
			mapView.isHidden = false
			
			let annotation = MKPointAnnotation()
			annotation.coordinate = coordinate
			mapView.addAnnotation(annotation)
		} else {
			mapView.isHidden = true
		}
	}
}

// MARK: - Private methods
private extension LocationCell {
	func setupUI() {
		backgroundColor = .background
		selectionStyle = .none
		iconImageView.image = Images.location
		layer.cornerRadius = 10
		layer.masksToBounds = true
	}
	
	func setupLayout() {
		contentView.addSubview(iconImageView)
		contentView.addSubview(titleLabel)
		contentView.addSubview(valueLabel)
		contentView.addSubview(mapView)
		
		NSLayoutConstraint.activate([
			iconImageView.heightAnchor.constraint(equalToConstant: 24),
			iconImageView.widthAnchor.constraint(equalToConstant: 24),
			iconImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: Padding.small),
			iconImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
			
			titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: Padding.small),
			titleLabel.leadingAnchor.constraint(equalTo: iconImageView.trailingAnchor, constant: Padding.small),
			titleLabel.trailingAnchor.constraint(equalTo: mapView.leadingAnchor, constant: -Padding.small),
			
			valueLabel.leadingAnchor.constraint(equalTo: iconImageView.trailingAnchor, constant: Padding.small),
			valueLabel.trailingAnchor.constraint(equalTo: mapView.leadingAnchor, constant: -Padding.small),
			valueLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: Padding.xsmall),
			valueLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -Padding.small),
			
			mapView.heightAnchor.constraint(equalToConstant: 100),
			mapView.widthAnchor.constraint(equalToConstant: 100),
			mapView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: Padding.small),
			mapView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -Padding.small),
			mapView.bottomAnchor.constraint(lessThanOrEqualTo: contentView.bottomAnchor, constant:  -Padding.small)
		])
	}
}
