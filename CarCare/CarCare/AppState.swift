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
		case needsVehicleRegistration, ready
	}

	@Published var status: Status = .needsVehicleRegistration
	@Published var error: AppError?
	@Published var showAlert: Bool = false

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
			self.error = AppError.bikeNotFound
			showAlert = true
		}
	}
}
