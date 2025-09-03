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
	@Published var overallStatus: MaintenanceStatus = .aPrevoir
	@Published var generalLastMaintenance: Maintenance? = nil
	@Published var error: AppError?
	@Published var showAlert: Bool = false
	
	//MARK: -Private properties
	private let loader: LocalMaintenanceLoader
	
	//MARK: -Initialization
	init(loader: LocalMaintenanceLoader = DependencyContainer.shared.MaintenanceLoader, notificationVM: NotificationViewModel? = nil) {
		self.loader = loader
		self.notificationVM = notificationVM
	}
	
	//MARK: -Methods
	// Méthode pour injecter notificationVM après initialisation
	   func setNotificationVM(_ notificationVM: NotificationViewModel) {
		   self.notificationVM = notificationVM
	   }

	func defineOverallMaintenanceStatus() -> MaintenanceStatus {
		print("defineOverallMaintenanceStatus appelée")
		
		let statuses = MaintenanceType.allCases
			.filter { $0 != .Unknown }
			.map { determineMaintenanceStatus(for: $0, maintenances: maintenances) }
	
		if statuses.contains(.aPrevoir) {
			return .aPrevoir
		} else if statuses.contains(.bientotAPrevoir) {
			return .bientotAPrevoir
		} else {
			return .aJour
		}
	}
	
	func fetchAllMaintenance() {
		print("fetchAllMaintenance appelée")
		do {
			let loaded = try loader.load()
			DispatchQueue.main.async {
				self.maintenances = loaded
				self.overallStatus = self.defineOverallMaintenanceStatus()
				print("overallStatus après fetch: \(self.overallStatus)")

			}
		} catch let error as LoadingCocoaError { //erreurs de load
			self.error = AppError.loadingDataFailed(error)
			showAlert = true
		} catch let error as StoreError { //erreurs de CoreDataLocalStore
			self.error = AppError.dataUnavailable(error)
			showAlert = true
		} catch let error as FetchCocoaError {
			self.error = AppError.fetchDataFailed(error)
			showAlert = true
		} catch {
			self.error = AppError.unknown
			showAlert = true
		}
	}
	
	func determineMaintenanceStatus(for maintenanceType: MaintenanceType, maintenances: [Maintenance]) -> MaintenanceStatus {
		print("determineMaintenanceStatus appelée")
			
			// Filtrer les maintenances de ce type
			let filtered = maintenances.filter { $0.maintenanceType == maintenanceType }
			
			// S'il n'y a jamais eu de maintenance, c'est à prévoir
			guard let lastMaintenance = filtered.max(by: { $0.date < $1.date }) else {
				return .aPrevoir
			}
			
			// Calculer la date de la prochaine maintenance
			let nextDate = Calendar.current.date(byAdding: .day, value: maintenanceType.frequencyInDays, to: lastMaintenance.date)!
			
			// Nombre de jours restants
			let daysRemaining = Calendar.current.dateComponents([.day], from: Date(), to: nextDate).day ?? 0
			let frequency = maintenanceType.frequencyInDays
			
			let proportion = min(max(Double(frequency - daysRemaining) / Double(frequency), 0), 1)
			
			switch proportion {
			case 0..<1/3:
				return .aJour          // Très récent
			case 1/3..<2/3:
				return .bientotAPrevoir // À prévoir bientôt
			default:
				return .aPrevoir       // Dépassé ou urgent
			}
	}

	func lastMaintenance(of type: MaintenanceType) -> Maintenance? {
		print("lastMaintenance appelée")
		let filtered = maintenances.filter { $0.maintenanceType == type }
		return filtered.max(by: { $0.date < $1.date })
	}
	
	func nextMaintenanceDate(for type: MaintenanceType) -> Date? {
		print("nextMaintenanceDate appelée")
		guard let lastMaintenance = lastMaintenance(of: type) else { return nil }
		guard type.frequencyInDays > 0 else { return nil} // Pas de prochaine date pour Unknown
		return Calendar.current.date(byAdding: .day, value: type.frequencyInDays, to: lastMaintenance.date)
	}
	
	func daysUntilNextMaintenance(type: MaintenanceType) -> Int? {
		print("daysUntilNextMaintenance appelée")
		guard let nextDate = nextMaintenanceDate(for: type) else { return nil }
		return Calendar.current.dateComponents([.day], from: Date(), to: nextDate).day
	}

	func calculateNumberOfMaintenance() -> Int {
		print("calculateNumberOfMaintenance appelée")
		return maintenances.count
	}
	//A mettre dans detailsViewVersion2
	func updateReminder(for maintenance: Maintenance, value: Bool) {
		print("updateReminder appelée")
		do {
			var updated = maintenance
			updated.reminder = value
			try loader.update(updated)
			
			if let index = maintenances.firstIndex(where: { $0.id == maintenance.id }) {
				maintenances[index] = updated
			}
			notificationVM?.updateReminder(for: updated, value: value)
		} catch let error as LoadingCocoaError { //erreurs de load
			self.error = AppError.loadingDataFailed(error)
			showAlert = true
		} catch let error as StoreError { //erreurs de CoreDataLocalStore
			self.error = AppError.dataUnavailable(error)
			showAlert = true
		} catch let error as FetchCocoaError {
			self.error = AppError.fetchDataFailed(error)
			showAlert = true
		} catch let error as SaveCocoaError {
			self.error = AppError.saveDataFailed(error)
			showAlert = true
		} catch {
			self.error = AppError.unknown
			showAlert = true
		}
	}
}
