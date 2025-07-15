//
//  CoreDataLocalStore+MileageRecord.swift
//  CarCare
//
//  Created by Ordinateur elena on 15/07/2025.
//

import CoreData

extension CoreDataLocalStore: MileageRecordStore {
	func insert(_ mileage: LocalMileageRecord) throws {
		try performSync { context in
			Result {
				try ManagedMileageRecord.new(from: mileage, in: context)
			}
		}
	}
	
	func retrieve() throws -> [LocalMileageRecord] {
		try performSync { context in
			Result {
				try ManagedMileageRecord.findAll(in: context)
					.map { $0.local }
			}
		}
	}
}
