//
//  MaintenanceVM.swift
//  CarCare
//
//  Created by Ordinateur elena on 20/08/2025.
//

import Foundation
import Combine

class MaintenanceVM: ObservableObject {
	weak var notificationVM: NotificationViewModel?  // Référence faible pour éviter les rétentions cycliques
	@Published var maintenances: [Maintenance] = []
	@Published var overallStatus: MaintenanceStatus = .aPrevoir
	@Published var generalLastMaintenance: Maintenance? = nil
	@Published var error: AppError?
	@Published var showAlert: Bool = false
	
	//MARK: -Private properties
	private let loader: LocalMaintenanceLoader
	private var cancellables = Set<AnyCancellable>()
	
	//MARK: -Initialization
	init(loader: LocalMaintenanceLoader = DependencyContainer.shared.MaintenanceLoader, notificationVM: NotificationViewModel? = nil) {
		self.loader = loader
		self.notificationVM = notificationVM
	}
	
	//MARK: -Methods
	func observeBikeType(_ bikeVM: BikeVM) {
		bikeVM.$bike
			.compactMap { $0?.bikeType }
			.sink { [weak self] bikeType in
				self?.fetchAllMaintenance(for: bikeType)
			}
			.store(in: &cancellables)
	}
	
	// Méthode pour injecter notificationVM après initialisation
	func setNotificationVM(_ notificationVM: NotificationViewModel) {
		self.notificationVM = notificationVM
	}
	
	func defineOverallMaintenanceStatus(for bikeType: BikeType) -> MaintenanceStatus {
		print("defineOverallMaintenanceStatus appelée")
		
		// Cas spécial : pas de maintenances → statut à prévoir
		guard !maintenances.isEmpty else {
			return .aPrevoir
		}
		
		let existingTypes = MaintenanceType.allCases
			.filter { $0 != .Unknown }
			.filter { !(bikeType == .Manual && $0 == .RunSoftwareAndBatteryDiagnostics) }
			// On ne garde que les types présents dans les maintenances
			.filter { type in
					maintenances.contains { (maintenance: Maintenance) in
						maintenance.maintenanceType == type
					}
				}
		
		let statuses = existingTypes.map { determineMaintenanceStatus(for: $0, maintenances: maintenances) }
		
		if statuses.contains(.aPrevoir) {
			return .aPrevoir
		} else if statuses.contains(.bientotAPrevoir) {
			return .bientotAPrevoir
		} else {
			return .aJour
		}
	}
	
	func fetchAllMaintenance(for bikeType: BikeType) {
		print("fetchAllMaintenance appelée")
		do {
			let loaded = try loader.load()
			
			// Filtrage : on exclut la maintenance batterie si le vélo est manuel
			let filtered: [Maintenance]
			if bikeType == .Manual {
				filtered = loaded.filter { $0.maintenanceType != .RunSoftwareAndBatteryDiagnostics }
			} else {
				filtered = loaded
			}
			
			DispatchQueue.main.async {
				self.maintenances = filtered
				print("Maintenances: \(self.maintenances)")
				self.overallStatus = self.defineOverallMaintenanceStatus(for: bikeType)
				print("overallStatus après fetch: \(self.overallStatus)")
				
			}
		} catch let error as LoadingCocoaError { //erreurs de load
			self.error = AppError.loadingDataFailed(error)
			showAlert = true
		} catch let error as StoreError { //erreurs de CoreDataManager
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

	func calculateNumberOfMaintenance() -> Int {
		print("calculateNumberOfMaintenance appelée")
		return maintenances.count
	}
    
	func updateReminder(for maintenance: Maintenance, value: Bool) {
		print("updateReminder appelée")
		do {
			var updated = maintenance
			updated.reminder = value
			try loader.update(updated)
			
			if let index = maintenances.firstIndex(where: { $0.id == maintenance.id }) {
				maintenances[index] = updated
			}
			
			// Calculer la prochaine date pour ce type
			let type = updated.maintenanceType
			if value {
				if let nextDate = nextMaintenanceDate(for: type) {
					let thirtyDaysFromNow = Date().addingTimeInterval(30*24*3600)
					
					// Planifie uniquement si la prochaine maintenance est dans moins de 30 jours et que l'utilisateur a autorisé les notifications
					if nextDate <= thirtyDaysFromNow,
					   notificationVM?.isAuthorized == true {
						notificationVM?.updateReminder(for: maintenance.id, value: value)
					}
				}
			} else {
				// Annule toutes les notifications pour ce type
				notificationVM?.cancelNotifications(for: type)
			}
			
		} catch let error as LoadingCocoaError { //erreurs de load
			self.error = AppError.loadingDataFailed(error)
			showAlert = true
		} catch let error as StoreError { //erreurs de CoreDataManager
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
	
	func deleteAllMaintenances() {
		do {
			try loader.deleteAll()
			self.maintenances = []
		} catch let error as SaveCocoaError {
			self.error = AppError.saveDataFailed(error)
			showAlert = true
		} catch {
			self.error = AppError.unknown
			showAlert = true
		}
	}
	
	func deleteOneMaintenance(maintenance: Maintenance, bikeType: BikeType) {
		do {
			try loader.deleteOne(maintenance)
			// Supprime localement du tableau pour mettre à jour la vue
			if let index = maintenances.firstIndex(of: maintenance) {
				maintenances.remove(at: index)
				overallStatus = defineOverallMaintenanceStatus(for: bikeType)
			}
		} catch {
			
		}
	}
	
	//pour notificationVM
	func nextMaintenanceDate(for type: MaintenanceType) -> Date? {
		// On récupère la dernière maintenance effectuée de ce type
		guard let last = lastMaintenance(of: type) else { return nil }
		// Vérifie que la fréquence est définie
		guard type.frequencyInDays > 0 else { return nil }
		// Calcule la prochaine date
		return Calendar.current.date(byAdding: .day, value: type.frequencyInDays, to: last.date)
	}
	
	// Renvoie la dernière maintenance effectuée pour un type donné
	func lastMaintenance(of type: MaintenanceType) -> Maintenance? {
		let filtered = maintenances.filter { $0.maintenanceType == type }
		return filtered.max(by: { $0.date < $1.date })
	}
    
    func calculateDaysSinceLastMaintenance(for type: MaintenanceType) -> Int? {
        guard let last = lastMaintenance(of: type) else { return nil }
        let calendar = Calendar.current
        let now = Date()
        let components = calendar.dateComponents([.day], from: last.date, to: now)
        return components.day ?? 0
    }
}
