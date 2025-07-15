//
//  CoreDataLocalStore+FuelRefillStore.swift
//  CarCare
//
//  Created by Ordinateur elena on 15/07/2025.
//

import CoreData

extension CoreDataLocalStore: FuelRefillStore {
	func insert(_ fuelRefill: LocalFuelRefill) throws {
		try performSync { context in
			Result {
				try ManagedFuelRefill.new(from: fuelRefill, in: context)
			}
		}
	}
	
	func retrieve () throws -> [LocalFuelRefill] {
		try performSync { context in
			Result {
				try ManagedFuelRefill.findAll(in: context)
					.map { $0.local } 
			}
		}
	}
}
