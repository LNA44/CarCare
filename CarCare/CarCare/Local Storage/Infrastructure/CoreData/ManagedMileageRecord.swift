//
//  ManagedMileageRecord.swift
//  CarCare
//
//  Created by Ordinateur elena on 15/07/2025.
//

import CoreData

@objc(ManagedMileageRecord)
class ManagedMileageRecord: NSManagedObject {
	@NSManaged var month: String
	@NSManaged var mileage: Int32
	@NSManaged var id: UUID
	
	@NSManaged var vehicle : ManagedVehicle
}

extension ManagedMileageRecord {
	static func findAll (in context: NSManagedObjectContext) throws -> [ManagedMileageRecord] {
		let request = NSFetchRequest<ManagedMileageRecord>(entityName: entity().name!)
		request.returnsObjectsAsFaults = false
		
		return try context.fetch(request)
	}
	
	static func new(from local: LocalMileageRecord, in context: NSManagedObjectContext) throws {
		let managed = ManagedMileageRecord(context: context)
		managed.month = local.month
		managed.mileage = Int32(local.mileage)
		managed.id = local.id
		
		try context.save()
	}
	
	var local: LocalMileageRecord {
		LocalMileageRecord(id: id, mileage: Int(mileage), month: month)
	}
}
