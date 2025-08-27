//
//  ManagedUser.swift
//  CarCare
//
//  Created by Ordinateur elena on 15/07/2025.
//

import CoreData

@objc(ManagedBike)
class ManagedBike: NSManagedObject {
	@NSManaged var id: UUID
	@NSManaged var year: Int32
	@NSManaged var model: String
	@NSManaged var brand: String
	@NSManaged var bikeType: String
	@NSManaged var maintenance : Set<ManagedMaintenance>?
	@NSManaged var identificationNumber: String
}

extension ManagedBike {
	static func find (in context: NSManagedObjectContext) throws -> [ManagedBike] {
		let request = NSFetchRequest<ManagedBike>(entityName: entity().name!)
		request.returnsObjectsAsFaults = false
		
		return try context.fetch(request)
	}
	
	static func new(from local: LocalBike, in context: NSManagedObjectContext) throws -> ManagedBike {
		let managed = ManagedBike(context: context)
		managed.id = local.id
		managed.year = Int32(local.year)
		managed.model = local.model
		managed.brand = local.brand.rawValue
		managed.bikeType = local.bikeType.rawValue
		managed.identificationNumber = local.identificationNumber
		
		try context.save()
		
		return managed
	}
	
	var local: LocalBike {
		LocalBike(id: id, year: Int(year), model: model, brand: Brand(rawValue: brand) ?? .Unknown, bikeType: BikeType(rawValue: bikeType) ?? .Manual, identificationNumber: identificationNumber)
	}
}

