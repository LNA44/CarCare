//
//  CoreDataLocalStore+VehicleStore.swift
//  CarCare
//
//  Created by Ordinateur elena on 15/07/2025.
//

import CoreData

extension CoreDataLocalStore: BikeStore {
	func insert(_ bike: LocalBike) throws {
		_ = try performSync { context in
			Result {
				try ManagedBike.new(from: bike, in: context)
			}
		}
	}
	
	func retrieve() throws -> LocalBike? {
		try performSync { context in
			Result {
				try ManagedBike.find(in: context).first.map {
                    LocalBike(id: $0.id, year: Int($0.year), model: $0.model, brand: $0.brand, bikeType: BikeType(rawValue: $0.bikeType) ?? .Manual, identificationNumber: $0.identificationNumber)
				}
			}
		}
	}
	
	func update(_ bike: LocalBike) throws {
		try performSync { context in
			Result {
				if let managedBike = try ManagedBike.find(in: context).first(where: { $0.id == bike.id }) {
					managedBike.brand = bike.brand
					managedBike.model = bike.model
					managedBike.year = Int32(bike.year)
					managedBike.bikeType = bike.bikeType.rawValue
					managedBike.identificationNumber = bike.identificationNumber
					try context.save()
				}
			}
		}
	}
	
	func delete(_ bike: LocalBike) throws {
		try performSync { context in
			Result {
				if let managedBike = try ManagedBike.find(in: context).first(where: { $0.id == bike.id }) {
					try ManagedBike.delete(managedBike, in: context)
					try context.save()
				}
			}
		}
	}
}
