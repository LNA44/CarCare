//
//  AppState.swift
//  CarCare
//
//  Created by Ordinateur elena on 22/07/2025.
//

import Foundation
import CoreData

class AppState: ObservableObject {
	enum Status {
		case loading, needsVehicleRegistration, ready
	}

	@Published var status: Status = .loading

	private let vehicleLoader: LocalBikeLoader

	init(vehicleLoader: LocalBikeLoader) {
		self.vehicleLoader = vehicleLoader
		checkVehiclePresence()
	}

	private func checkVehiclePresence() {
		do {
			let vehicle = try self.vehicleLoader.load()
			if vehicle == nil {
				status = .needsVehicleRegistration
			} else {
				status = .ready
			}
		} catch {
			print("Erreur Core Data :", error)
			status = .needsVehicleRegistration
		}
	}

	/*func refresh() {
		checkVehiclePresence()
	}*/
}
