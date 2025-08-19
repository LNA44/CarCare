//
//  MaintenanceVM.swift
//  CarCare
//
//  Created by Ordinateur elena on 19/08/2025.
//

import Foundation

class MaintenanceVM: ObservableObject {
	//MARK: -Public properties
	@Published var maintenances: [Maintenance] = []
	
	//MARK: -Private properties
	private let loader: LocalMaintenanceLoader
	
	//MARK: -Initialization
	init(loader: LocalMaintenanceLoader = DependencyContainer.shared.MaintenanceLoader) {
		self.loader = loader
	}
	
	//MARK: -Methods
	func fetchAllMaintenance() {
		do {
			maintenances = try loader.load()
		} catch {
			print("erreur dans le chargement de toutes les maintenances")
			maintenances = []
		}
	}
	
	func lastMaintenance(of type: MaintenanceType) -> Maintenance? {
		let filtered = maintenances.filter { $0.maintenanceType == type }
		return filtered.max(by: { $0.date < $1.date })
	}
	
	func nextMaintenanceDate(for type: MaintenanceType) -> Date? {
		guard let lastMaintenance = lastMaintenance(of: type) else { return nil }
		guard type.frequencyInDays > 0 else { return nil} // Pas de prochaine date pour Unknown
		return Calendar.current.date(byAdding: .day, value: type.frequencyInDays, to: lastMaintenance.date)
	}
	
	func daysUntilNextMaintenance(type: MaintenanceType) -> Int? {
		guard let nextDate = nextMaintenanceDate(for: type) else { return nil }
		return Calendar.current.dateComponents([.day], from: Date(), to: nextDate).day
	}
}
