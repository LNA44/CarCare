//
//  DashboardVM.swift
//  CarCare
//
//  Created by Ordinateur elena on 24/07/2025.
//

import Foundation

final class DashboardVM: ObservableObject {
	//MARK: -Public properties
	@Published var model: String = ""
	@Published var brand: Brand = .Unknown
	@Published var mileage: Int = 0
	@Published var year: Int = 0
	@Published var lastMaintenance: Maintenance? = nil
	
	
	//MARK: -Private properties
	private let loader: LocalMaintenanceLoader
	
	//MARK: -Initialization
	init(loader: LocalMaintenanceLoader = DependencyContainer.shared.MaintenanceLoader) {
		self.loader = loader
	}
	
	//MARK: -Methods
	func fetchLastMaintenance() {
		do {
			let allMaintenance = try loader.load()
			let sortedMaintenance = allMaintenance.sorted { $0.date > $1.date } //tri décroissant
			if let lastMaintenance = sortedMaintenance.first {
				self.lastMaintenance = lastMaintenance
			}
		} catch {
			print("erreur dans le chargement de la denrière maintenance")
		}
	}
	
	func fetchFutureMaintenance() {
		//A IMPLEMENTER
	}
	
}
