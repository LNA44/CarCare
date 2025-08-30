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
	/*@Published var generalLastMaintenance: Maintenance? = nil
	@Published var selectedMaintenanceType: MaintenanceType {
		didSet {
				generalLastMaintenance = maintenances
					.filter { $0.maintenanceType == selectedMaintenanceType }
					.max(by: { $0.date < $1.date })
				generalLastMaintenance = nil
		}
	}
	@Published var selectedMaintenanceDate: Date {
		didSet {
				generalLastMaintenance = maintenances
					.filter { $0.maintenanceType == selectedMaintenanceType }
					.max(by: { $0.date < $1.date })
				generalLastMaintenance = nil
		}
	}
	@Published var maintenancesForOneType: [Maintenance] = []
	@Published var nextMaintenanceDates: [MaintenanceType: Date?] = [:]
	@Published var daysUntilNextMaintenance: [MaintenanceType: Int?] = [:]*/
	@Published var overallStatus: MaintenanceStatus = .aPrevoir
	@Published var error: AppError?
	@Published var showAlert: Bool = false
	
	//MARK: -Private properties
	private let loader: LocalMaintenanceLoader
	
	//MARK: -Initialization
	init(loader: LocalMaintenanceLoader = DependencyContainer.shared.MaintenanceLoader, notificationVM: NotificationViewModel? = nil) {
		self.loader = loader
		//self.selectedMaintenanceType = selectedMaintenanceType
		//self.selectedMaintenanceDate = selectedMaintenanceDate
		self.notificationVM = notificationVM
	}
	
	//MARK: -Methods
	// Méthode pour injecter notificationVM après initialisation
	   func setNotificationVM(_ notificationVM: NotificationViewModel) {
		   self.notificationVM = notificationVM
	   }
#warning("pourquoi async nécessaire?")
	/*func fetchLastMaintenance() {
		print("fetchLastMaintenance appelée")
		DispatchQueue.global(qos: .userInitiated).async { //chargement hors du thread principal
			do {
				let allMaintenance = try self.loader.load()
				let sortedMaintenance = allMaintenance
					.sorted { $0.date > $1.date } //tri décroissant
				DispatchQueue.main.async {
					self.generalLastMaintenance = sortedMaintenance.first
				}
			} catch let error as LoadingCocoaError { //erreurs de load
				DispatchQueue.main.async {
					self.error = AppError.loadingDataFailed(error)
					self.showAlert = true
				}
			} catch let error as StoreError { //erreurs de CoreDataLocalStore
				DispatchQueue.main.async {
					self.error = AppError.dataUnavailable(error)
					self.showAlert = true
				}
			} catch let error as FetchCocoaError {
				DispatchQueue.main.async {
					self.error = AppError.fetchDataFailed(error)
					self.showAlert = true
				}
			} catch {
				DispatchQueue.main.async {
					self.error = AppError.unknown
					self.showAlert = true
				}
			}
		}
	}*/
	
	/*func fetchAllMaintenanceForOneType(type: MaintenanceType) {
		print("fetchAllMaintenanceForOneType appelée")
		do {
			let allMaintenance = try loader.load()
			self.maintenancesForOneType = allMaintenance.filter { $0.maintenanceType == type }
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
	}*/
	
	func defineOverallMaintenanceStatus() -> MaintenanceStatus {
		print("defineOverallMaintenanceStatus appelée")
		let allUpToDate = MaintenanceType.allCases
			.filter { $0 != .Unknown } // on ignore Unknown
			.allSatisfy { type in
				determineMaintenanceStatus(for: type, maintenances: maintenances) == .aJour
			}
		
		return allUpToDate ? .aJour : .aPrevoir
	}
	
	func fetchAllMaintenance() {
		print("fetchAllMaintenance appelée")
		do {
			let loaded = try loader.load()
			DispatchQueue.main.async {
				self.maintenances = loaded
				self.overallStatus = self.defineOverallMaintenanceStatus()
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
	
	/*func addMaintenance() {
		print("addMaintenance appelée")
		let maintenance = Maintenance(id: UUID(), maintenanceType: selectedMaintenanceType, date: selectedMaintenanceDate, reminder: true)
		do {
			try loader.save(maintenance)
		} catch let error as LoadingCocoaError { //erreurs de load
			self.error = AppError.loadingDataFailed(error)
			showAlert = true
		} catch let error as StoreError { //erreurs de CoreDataLocalStore
			self.error = AppError.dataUnavailable(error)
			showAlert = true
		} catch let error as SaveCocoaError {
			self.error = AppError.saveDataFailed(error)
			showAlert = true
		} catch {
			self.error = AppError.unknown
			showAlert = true
		}
	}*/
	
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
	
	// Pré-calcul pour la vue
	/*func updateMaintenanceCache() { //tableau de chaque type avec dates et jours restants
		print("updateMaintenanceCache appelée")
		var nextDates: [MaintenanceType: Date?] = [:]
		var daysRemaining: [MaintenanceType: Int?] = [:]
		
		for type in MaintenanceType.allCases where type != .Unknown {
			let nextDate = nextMaintenanceDate(for: type)
			nextDates[type] = nextDate
			daysRemaining[type] = nextDate.map { Calendar.current.dateComponents([.day], from: Date(), to: $0).day }
		}
		
		DispatchQueue.main.async {
			self.nextMaintenanceDates = nextDates
			self.daysUntilNextMaintenance = daysRemaining
		}
	}*/
	
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
