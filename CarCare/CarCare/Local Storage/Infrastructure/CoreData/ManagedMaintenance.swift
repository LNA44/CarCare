//
//  ManagedMaintenance.swift
//  CarCare
//
//  Created by Ordinateur elena on 15/07/2025.
//

import CoreData

@objc(ManagedMaintenance)
class ManagedMaintenance: NSManagedObject {
	@NSManaged var maintenanceType: String
	@NSManaged var cost: Double
	@NSManaged var date: Date
	@NSManaged var id: UUID
	
	@NSManaged var vehicle : ManagedVehicle
}

extension ManagedMaintenance {
	static func findAll (in context: NSManagedObjectContext) throws -> [ManagedMaintenance] {
		let request = NSFetchRequest<ManagedMaintenance>(entityName: entity().name!)
		request.returnsObjectsAsFaults = false
		
		return try context.fetch(request)
	}
	
	static func new(from local: LocalMaintenance, in context: NSManagedObjectContext) throws {
		let managed = ManagedMaintenance(context: context)
		managed.maintenanceType = local.maintenanceType
		managed.cost = local.cost
		managed.date = local.date
		managed.id = local.id
		
		try context.save()

	}
	
	var local: LocalMaintenance { 
		LocalMaintenance(id: id, maintenanceType: maintenanceType, date: date, cost: Double(cost))
	}
}
