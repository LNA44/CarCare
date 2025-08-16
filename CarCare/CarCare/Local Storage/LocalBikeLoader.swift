//
//  LocalVehicleLoader.swift
//  CarCare
//
//  Created by Ordinateur elena on 22/07/2025.
//

import Foundation

struct LocalBikeLoader {
	
	private let store : BikeStore
	
	init(store: BikeStore) {
		self.store = store
	}
	
	func load() throws -> Bike? {
		try store.retrieve()?.toModel()
	}
	
	func save(_ bike: Bike) throws {
		try store.insert(bike.toLocal())
	}
}

private extension Bike {
	func toLocal() -> LocalBike {
		LocalBike(id: id, year: year,model: model, brand: brand, bikeType: bikeType)
	}
}


private extension LocalBike {
	func toModel() -> Bike {
		Bike(id: id, brand: brand, model: model, year: year, bikeType: bikeType)
	}
}
