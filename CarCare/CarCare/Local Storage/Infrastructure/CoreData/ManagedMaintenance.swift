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
	@NSManaged var date: Date
	@NSManaged var id: UUID
	@NSManaged var status: Int
	@NSManaged var reminder: Bool
	
	@NSManaged var vehicle : ManagedBike
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
		managed.date = local.date
		managed.id = local.id
		managed.reminder = local.reminder
		
		try context.save()

	}
	
	static func update(from local: LocalMaintenance, in context: NSManagedObjectContext) throws {
		// Cherche l'objet existant
		let request = NSFetchRequest<ManagedMaintenance>(entityName: entity().name!)
		request.predicate = NSPredicate(format: "id == %@", local.id as CVarArg)
		request.returnsObjectsAsFaults = false
		
		if let existing = try context.fetch(request).first {
			existing.reminder = local.reminder
			try context.save()
		}
	}
	
	var local: LocalMaintenance {
		LocalMaintenance(id: id, maintenanceType: maintenanceType, date: date, reminder: reminder)
	}
}
