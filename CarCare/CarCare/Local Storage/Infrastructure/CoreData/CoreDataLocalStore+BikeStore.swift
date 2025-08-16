//
//  CoreDataLocalStore+VehicleStore.swift
//  CarCare
//
//  Created by Ordinateur elena on 15/07/2025.
//

import CoreData

extension CoreDataLocalStore: BikeStore {
	func insert(_ bike: LocalBike) throws {
		try performSync { context in
			Result {
				try ManagedBike.new(from: bike, in: context)
			}
		}
	}
	
	func retrieve() throws -> LocalBike? {
		try performSync { context in
			Result {
				try ManagedBike.find(in: context).first.map {
					LocalBike(id: $0.id, year: Int($0.year), model: $0.model, brand: Brand(rawValue: $0.brand) ?? .Unknown, bikeType: BikeType(rawValue: $0.bikeType) ?? .Manual)
				}
			}
		}
	}
}
