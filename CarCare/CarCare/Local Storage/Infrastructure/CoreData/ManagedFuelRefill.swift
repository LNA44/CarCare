//
//  ManagedFuelRefill.swift
//  CarCare
//
//  Created by Ordinateur elena on 15/07/2025.
//

import CoreData

@objc(ManagedFuelRefill)
class ManagedFuelRefill: NSManagedObject {
	@NSManaged var fuelType: String
	@NSManaged var amount: Int32
	@NSManaged var date: Date
	@NSManaged var id: UUID
	
	@NSManaged var vehicle : ManagedVehicle
}

extension ManagedFuelRefill {
	static func findAll (in context: NSManagedObjectContext) throws -> [ManagedFuelRefill] {
		let request = NSFetchRequest<ManagedFuelRefill>(entityName: entity().name!)
		request.returnsObjectsAsFaults = false
		
		return try context.fetch(request)
	}
	
	static func new(from local: LocalFuelRefill, in context: NSManagedObjectContext) throws {
		let managed = ManagedFuelRefill(context: context)
		managed.fuelType = local.fuelType
		managed.amount = Int32(local.amount)
		managed.id = local.id
		managed.date = local.date
	
		try context.save()
	}
	
	var local: LocalFuelRefill { //propriété calculée de type LocalFuelRefill
		LocalFuelRefill(id: id, date: date, amount: Int(amount), fuelType: fuelType)
	}
}
