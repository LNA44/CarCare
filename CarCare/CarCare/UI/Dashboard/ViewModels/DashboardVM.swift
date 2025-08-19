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
	@Published var selectedMaintenanceType: MaintenanceType {
		didSet {
			let maintenances = fetchAllMaintenance()
			lastMaintenance = maintenances
				.filter { $0.maintenanceType == selectedMaintenanceType }
				.max(by: { $0.date < $1.date })
		}
	}
	@Published var selectedMaintenanceDate: Date {
		didSet {
			let maintenances = fetchAllMaintenance()
			lastMaintenance = maintenances
				.filter { $0.maintenanceType == selectedMaintenanceType }
				.max(by: { $0.date < $1.date })
		}
	}
	@Published var bike: Bike? = nil
	
	//MARK: -Private properties
	private let maintenanceLoader: LocalMaintenanceLoader
	private let bikeLoader: LocalBikeLoader
	
	//MARK: -Initialization
	init(maintenanceLoader: LocalMaintenanceLoader = DependencyContainer.shared.MaintenanceLoader,
		 bikeLoader: LocalBikeLoader = DependencyContainer.shared.BikeLoader, selectedMaintenanceType: MaintenanceType = .Unknown, selectedMaintenanceDate: Date = Date()) {
		self.maintenanceLoader = maintenanceLoader
		self.bikeLoader = bikeLoader
		self.selectedMaintenanceType = selectedMaintenanceType
		self.selectedMaintenanceDate = selectedMaintenanceDate
	}
	
	//MARK: -Methods
	func fetchBikeData() {
		do {
			guard let unwrappedBike = try bikeLoader.load() else {
				print("problème de chargement du vélo")
				return
			}
			self.model = unwrappedBike.model
			self.brand = unwrappedBike.brand
			self.year = unwrappedBike.year
			bike = unwrappedBike
		} catch {
			print("erreur dans le chargement du vélo")
		}
	}
	
	func fetchLastMaintenance() {
		do {
			let allMaintenance = try maintenanceLoader.load()
			let sortedMaintenance = allMaintenance
				.sorted { $0.date > $1.date } //tri décroissant
			self.lastMaintenance = sortedMaintenance.first
		} catch {
			print("erreur dans le chargement de la dernière maintenance")
		}
	}
	
	
	func overallMaintenanceStatus() -> MaintenanceStatus {
		//pour vérifier que tous les status des entretiens sont au vert sinon afficher "à prévoir"
		let maintenances = fetchAllMaintenance()
		let allUpToDate = MaintenanceType.allCases
			.filter { $0 != .Unknown } // on ignore Unknown
			.allSatisfy { type in
				determineMaintenanceStatus(for: type, maintenances: maintenances) == .aJour
			}

		return allUpToDate ? .aJour : .aPrevoir
	}
	
	func fetchAllMaintenance() -> [Maintenance] {
		do {
			return try maintenanceLoader.load()
		} catch {
			print("erreur dans le chargement de toutes les maintenances")
			return []
		}
	}
	
	func determineMaintenanceStatus(for maintenanceType: MaintenanceType, maintenances: [Maintenance]) -> MaintenanceStatus {
		// On récupère les maintenances de ce type
		let filtered = maintenances.filter { $0.maintenanceType.rawValue == maintenanceType.rawValue }
		// S'il n'y a jamais eu de maintenance, c'est à prévoir
		guard let lastMaintenance = filtered.max(by: { $0.date < $1.date }) else {
			return .aPrevoir
		}
		// Calculer la date à laquelle la prochaine maintenance est due
		let dueDate = Calendar.current.date(byAdding: .day, value: maintenanceType.frequencyInDays, to: lastMaintenance.date)!
		// Si la date due est dans le futur ou aujourd'hui => à jour, sinon => à prévoir
			return dueDate >= Date() ? .aJour : .aPrevoir
	}
	
	func addMaintenance() {
		let maintenance = Maintenance(id: UUID(), maintenanceType: selectedMaintenanceType, date: selectedMaintenanceDate)
		do {
			try maintenanceLoader.save(maintenance)
			print("maintenance sauvegardée avec succès")
			fetchLastMaintenance()
		} catch {
			print("erreur lors de la sauvegarde de la maintenance")
		}
	}
	
	func modifyBikeInformations(brand: Brand, model: String, year: Int, type: BikeType) {
		guard bike != nil else { return }
			bike!.brand = brand
			bike!.model = model
			bike!.year = year
			bike!.bikeType = type
		do {
			try bikeLoader.save(bike!)
		} catch {
			print("erreur lors de la modification du vélo")
		}
	}
}
