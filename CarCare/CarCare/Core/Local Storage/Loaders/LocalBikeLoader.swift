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
		if let _ = try store.retrieve() { //Si velo existe déjà on le met à jour
			try store.update(bike.toLocal())
		} else {
			try store.insert(bike.toLocal()) //sinon on le crée
		}
	}
	
	func delete(_ bike: Bike) throws {
		try store.delete(bike.toLocal())
	}
}

extension Bike {
	func toLocal() -> LocalBike {
        LocalBike(id: id, year: year,model: model, brand: brand, bikeType: bikeType, identificationNumber: identificationNumber, imageData: imageData)
	}
}


extension LocalBike {
	func toModel() -> Bike {
		Bike(id: id, brand: brand, model: model, year: year, bikeType: bikeType, identificationNumber: identificationNumber, imageData: imageData)
	}
}
