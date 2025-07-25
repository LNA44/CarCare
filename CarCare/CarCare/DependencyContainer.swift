//
//  DependencyContainer.swift
//  CarCare
//
//  Created by Ordinateur elena on 22/07/2025.
//

import CoreData

final class DependencyContainer {
	
	static let shared = DependencyContainer()
	
	lazy var store: MaintenanceStore & BikeStore = {
		do {
			let storeURL = NSPersistentContainer
				.defaultDirectoryURL()
				.appendingPathComponent("CarCare.sqlite")
			
			return try CoreDataLocalStore(storeURL: storeURL)
		} catch {
			return NullStore()
		}
	} ()
	
	lazy var MaintenanceLoader: LocalMaintenanceLoader = {
		LocalMaintenanceLoader(store: store)
	} ()
	
	lazy var VehicleLoader: LocalBikeLoader = {
		LocalBikeLoader(store: store)
	} ()
}
