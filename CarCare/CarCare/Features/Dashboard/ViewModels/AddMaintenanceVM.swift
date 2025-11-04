//
//  AddMaintenanceVM.swift
//  CarCare
//
//  Created by Ordinateur elena on 30/08/2025.
//

import Foundation

final class AddMaintenanceVM: ObservableObject {
	private let maintenanceVM: MaintenanceVM
	private let maintenanceLoader: LocalMaintenanceLoader
	@Published var error: AppError?
	@Published var showAlert: Bool = false
	@Published var selectedMaintenanceType: MaintenanceType = .Unknown 
	@Published var selectedMaintenanceDate: Date? = Date()
	private var notificationVM: NotificationViewModel
	
	init(maintenanceLoader: LocalMaintenanceLoader = DependencyContainer.shared.MaintenanceLoader, maintenanceVM: MaintenanceVM, notificationVM: NotificationViewModel) {
		self.maintenanceLoader = maintenanceLoader
		self.maintenanceVM = maintenanceVM
		self.notificationVM = notificationVM
	}
	
	func addMaintenance(bikeType: BikeType) {
		if let selectedMaintenanceDate = selectedMaintenanceDate {
			let maintenance = Maintenance(id: UUID(), maintenanceType: selectedMaintenanceType, date: selectedMaintenanceDate, reminder: true)
			do {
				try maintenanceLoader.save(maintenance)
				maintenanceVM.fetchAllMaintenance(for: bikeType)
				if let nextDate = calculateNextMaintenanceDate(for: selectedMaintenanceType, baseMaintenance: maintenance) {
					notificationVM.scheduleNotifications(for: selectedMaintenanceType, until: nextDate)
				}
				
			} catch let error as LoadingCocoaError { //erreurs de load
				self.error = AppError.loadingDataFailed(error)
				showAlert = true
			} catch let error as StoreError { //erreurs de CoreDataManager
				self.error = AppError.dataUnavailable(error)
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
	
	func filteredMaintenanceTypes(for bikeType: BikeType) -> [MaintenanceType] {
		if bikeType == .Manual {
			return MaintenanceType.allCases.filter { $0 != .RunSoftwareAndBatteryDiagnostics }
		} else {
			return MaintenanceType.allCases
		}
	}
	
	/*func calculateDaysUntilNextMaintenance(type: MaintenanceType) -> Int? {
		guard let nextDate = nextMaintenanceDate(for: type) else { return nil}
		return Calendar.current.dateComponents([.day], from: Date(), to: nextDate).day
	}*/
	
	func calculateNextMaintenanceDate(for type: MaintenanceType, baseMaintenance: Maintenance? = nil) -> Date? {
		// Priorité à la dernière maintenance existante
		let lastMaintenanceToUse = getLastMaintenance(of: type) ?? baseMaintenance
		guard let lastMaintenance = lastMaintenanceToUse else { return nil }
		guard type.frequencyInDays > 0 else { return nil }
		return Calendar.current.date(byAdding: .day, value: type.frequencyInDays, to: lastMaintenance.date)
	}
	
	func getLastMaintenance(of type: MaintenanceType) -> Maintenance? {
		let filtered = maintenanceVM.maintenances.filter { $0.maintenanceType == type }
		return filtered.max(by: { $0.date < $1.date })
	}
}
