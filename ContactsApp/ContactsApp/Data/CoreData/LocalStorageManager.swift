//
//  LocalStorageManager.swift
//  ContactsApp
//
//  Created by Stanislav KUTSENKO on 01/04/2025.
//

import Foundation
import CoreData

class LocalStorageManager {
	// MARK: - Properties
	private let modelName: String
	
	private lazy var managedContext: NSManagedObjectContext = {
		return self.storeContainer.viewContext
	}()
	
	private lazy var storeContainer: NSPersistentContainer = {
		let container = NSPersistentContainer(name: self.modelName)
		let description = container.persistentStoreDescriptions.first
		description?.shouldMigrateStoreAutomatically = true
		description?.shouldInferMappingModelAutomatically = true
		
		container.loadPersistentStores { _, error in
			if let error = error as NSError? {
				print("Unresolved error \(error), \(error.userInfo)")
			}
		}
		return container
	}()
	
	// MARK: - Init
	init(modelName: String) {
		self.modelName = modelName
	}
	
	// MARK: - Methods
	func saveContext() {
		guard managedContext.hasChanges else { return }
		
		do {
			try managedContext.save()
		} catch let error as NSError {
			print("Unresolved error \(error), \(error.userInfo)")
		}
	}
	
	func deleteAll() {
		let contactRequest: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: "ContactEntity")
		let deleteContactRequest = NSBatchDeleteRequest(fetchRequest: contactRequest)
		
		let dateRequest: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: "DateAgeEntity")
		let deleteDateRequest = NSBatchDeleteRequest(fetchRequest: dateRequest)
		
		let nameRequest: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: "NameEntity")
		let deleteNameRequest = NSBatchDeleteRequest(fetchRequest: nameRequest)
		
		let locationRequest: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: "LocationEntity")
		let deleteLocationRequest = NSBatchDeleteRequest(fetchRequest: locationRequest)
		
		let coordinatesRequest: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: "CoordinatesEntity")
		let deleteCoordinatesRequest = NSBatchDeleteRequest(fetchRequest: coordinatesRequest)
		
		let picturesRequest: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: "PicturesEntity")
		let deletePicturesRequest = NSBatchDeleteRequest(fetchRequest: picturesRequest)
		
		_ = try? managedContext.execute(deleteContactRequest) as? NSBatchDeleteResult
		_ = try? managedContext.execute(deleteDateRequest) as? NSBatchDeleteResult
		_ = try? managedContext.execute(deleteLocationRequest) as? NSBatchDeleteResult
		_ = try? managedContext.execute(deleteNameRequest) as? NSBatchDeleteResult
		_ = try? managedContext.execute(deleteCoordinatesRequest) as? NSBatchDeleteResult
		_ = try? managedContext.execute(deletePicturesRequest) as? NSBatchDeleteResult
	}
	
	func syncContacts(_ contacts: [Contact]) {
		for contact in contacts {
			let nameEntity = NameEntity(context: managedContext)
			nameEntity.id = UUID()
			nameEntity.title = contact.name.title
			nameEntity.firstName = contact.name.firstName
			nameEntity.lastName = contact.name.lastName
			
			let birthdayEntity = DateAgeEntity(context: managedContext)
			birthdayEntity.id = UUID()
			birthdayEntity.age = Int16(contact.dateOfBirth.age)
			birthdayEntity.date = contact.dateOfBirth.date
			
			let coordinatesEntity = CoordinatesEntity(context: managedContext)
			coordinatesEntity.id = UUID()
			coordinatesEntity.latitude = Double(contact.location?.coordinates?.latitude ?? "0") ?? 0
			coordinatesEntity.longitude = Double(contact.location?.coordinates?.longitude ?? "0") ?? 0
			
			let picturesEntity = PicturesEntity(context: managedContext)
			picturesEntity.id = UUID()
			
			if let thumbnailUrl = contact.picture?.thumbnail {
				picturesEntity.thumbnail = thumbnailUrl
			}
			
			if let largeUrl = contact.picture?.large {
				picturesEntity.large = largeUrl
			}
			
			let locationEntity = LocationEntity(context: managedContext)
			locationEntity.id = UUID()
			locationEntity.address = contact.location?.address
			locationEntity.coordinates = coordinatesEntity
			
			let contactEntity = ContactEntity(context: managedContext)
			contactEntity.id = UUID()
			contactEntity.email = contact.email
			contactEntity.phone = contact.phone
			contactEntity.cellPhone = contact.cellPhone
			contactEntity.gender = contact.gender
			contactEntity.nationality = contact.nationality
			contactEntity.birthday = birthdayEntity
			contactEntity.pictures = picturesEntity
			contactEntity.name = nameEntity
			contactEntity.location = locationEntity
			saveContext()
		}
	}
	
	func fetchContacts() -> [Contact]? {
		let fetchRequest = NSFetchRequest<ContactEntity>(entityName: "ContactEntity")
		
		do {
			let contactEntities = try managedContext.fetch(fetchRequest)
			return contactEntities.map(mapDataToDomain(entity:))
		} catch {
			return nil
		}
	}
	
	private func mapDataToDomain(entity: ContactEntity) -> Contact {
		let name = Name(
			title: entity.name?.title,
			firstName: entity.name?.firstName ?? "",
			lastName: entity.name?.lastName ?? ""
		)
		
		let coordinates = Coordinates(
			latitude: String(describing: entity.location?.coordinates?.latitude),
			longitude: String(describing: entity.location?.coordinates?.longitude)
		)
		
		let location = Location(
			address: entity.location?.address,
			coordinates: coordinates
		)
		
		let dateOfBirth = DateAge(
			date: entity.birthday?.date,
			age: Int(entity.birthday?.age ?? 0)
		)
		
		let picture = Picture(
			thumbnail: entity.pictures?.thumbnail,
			large: entity.pictures?.large
		)
		
		return Contact(
			name: name,
			gender: entity.gender ?? "",
			location: location,
			email: entity.email,
			phone: entity.phone,
			cellPhone: entity.cellPhone,
			picture: picture,
			nationality: entity.nationality,
			dateOfBirth: dateOfBirth
		)
	}
}

