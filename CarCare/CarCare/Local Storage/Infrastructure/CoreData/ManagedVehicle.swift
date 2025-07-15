//
//  ManagedUser.swift
//  CarCare
//
//  Created by Ordinateur elena on 15/07/2025.
//

import CoreData

@objc(ManagedVehicle)
class ManagedVehicle: NSManagedObject {
	@NSManaged var year: Int32
	@NSManaged var totalFuelCost: Double
	@NSManaged var model: String
	@NSManaged var mileage: String
	@NSManaged var fuel: String
	@NSManaged var brand: String


	
	@NSManaged var fuelRefill : Set<ManagedFuelRefill>?
	@NSManaged var maintenance : Set<ManagedMaintenance>?
	@NSManaged var mileageRecord : Set<ManagedMileageRecord>?
}

extension ManagedVehicle {
	static func find (in context: NSManagedObjectContext) throws -> [ManagedVehicle] {
		let request = NSFetchRequest<ManagedVehicle>(entityName: entity().name!)
		request.returnsObjectsAsFaults = false
		
		return try context.fetch(request)
	}
	
	static func new(from local: LocalVehicle, in context: NSManagedObjectContext) throws {
		let managed = ManagedVehicle(context: context)
		managed.year = Int32(local.year)
		managed.totalFuelCost = local.totalFuelCost
		managed.model = local.model
		managed.brand = local.brand
		managed.mileage = local.mileage
		managed.fuel = local.fuel
		
		try context.save()
	}
	
	var local: LocalVehicle {
		LocalVehicle(year: Int(year), totalFuelCost: totalFuelCost, model: model, brand: brand, mileage: mileage, fuel: fuel)
	}
}
