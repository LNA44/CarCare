//
//  MaintenanceVM.swift
//  CarCare
//
//  Created by Ordinateur elena on 20/08/2025.
//

import Foundation

final class MaintenanceVM: ObservableObject {
	weak var notificationVM: NotificationViewModel?  // Référence faible pour éviter les rétentions cycliques
	@Published var maintenances: [Maintenance] = []
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
	@Published var maintenancesForOneType: [Maintenance] = []
	
	//MARK: -Private properties
	private let loader: LocalMaintenanceLoader
	
	//MARK: -Initialization
	init(loader: LocalMaintenanceLoader = DependencyContainer.shared.MaintenanceLoader, selectedMaintenanceType: MaintenanceType = .Unknown, selectedMaintenanceDate: Date = Date(), notificationVM: NotificationViewModel? = nil) {
		self.loader = loader
		self.selectedMaintenanceType = selectedMaintenanceType
		self.selectedMaintenanceDate = selectedMaintenanceDate
		self.notificationVM = notificationVM
	}
	
	//MARK: -Methods
	// Méthode pour injecter notificationVM après initialisation
	   func setNotificationVM(_ notificationVM: NotificationViewModel) {
		   self.notificationVM = notificationVM
	   }
	
	func fetchLastMaintenance() {
		do {
			let allMaintenance = try loader.load()
			let sortedMaintenance = allMaintenance
				.sorted { $0.date > $1.date } //tri décroissant
			self.lastMaintenance = sortedMaintenance.first
		} catch {
			print("erreur dans le chargement de la dernière maintenance")
		}
	}
	
	func fetchAllMaintenanceForOneType(type: MaintenanceType) {
		do {
			let allMaintenance = try loader.load()
			self.maintenancesForOneType = allMaintenance.filter { $0.maintenanceType == type }
		} catch {
			print("erreur dans le chargement des maintenances passées")
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
			let loaded = try loader.load()
			DispatchQueue.main.async {
				self.maintenances = loaded
			}
			return loaded
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
		let maintenance = Maintenance(id: UUID(), maintenanceType: selectedMaintenanceType, date: selectedMaintenanceDate, reminder: true)
		do {
			try loader.save(maintenance)
			print("maintenance sauvegardée avec succès")
			fetchLastMaintenance()
		} catch {
			print("erreur lors de la sauvegarde de la maintenance")
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
	
	func calculateNumberOfMaintenance() -> Int {
		return maintenances.count
	}
	
	func updateReminder(for maintenance: Maintenance, value: Bool) {
		do {
			var updated = maintenance
			updated.reminder = value
			try loader.update(updated)
			
			if let index = maintenances.firstIndex(where: { $0.id == maintenance.id }) {
				maintenances[index] = updated
			}
			notificationVM?.updateReminder(for: updated, value: value)
		} catch {
			print("erreur dans la modif de la maintenance")
		}
	}
}
