//
//  CoreDataLocalStore+VehicleStore.swift
//  CarCare
//
//  Created by Ordinateur elena on 15/07/2025.
//

import CoreData

extension CoreDataLocalStore: VehicleStore {
	func insert(_ vehicle: LocalVehicle) throws {
		try performSync { context in
			Result {
				try ManagedVehicle.new(from: vehicle, in: context)
			}
		}
	}
}
