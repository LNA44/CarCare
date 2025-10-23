//
//  MaintenanceDetailsVM.swift
//  CarCare
//
//  Created by Ordinateur elena on 02/09/2025.
//

import Foundation

final class MaintenanceDetailsVM: ObservableObject {
	private let maintenanceVM: MaintenanceVM
	private let maintenanceLoader: LocalMaintenanceLoader
	@Published var error: AppError?
	@Published var showAlert: Bool = false
	@Published var daysUntilNextMaintenance: Int?
	@Published var maintenancesForOneType: [Maintenance] = []
	
	init(maintenanceLoader: LocalMaintenanceLoader = DependencyContainer.shared.MaintenanceLoader, maintenanceVM: MaintenanceVM) {
		self.maintenanceLoader = maintenanceLoader
		self.maintenanceVM = maintenanceVM
	}
	
	func daysUntilNextMaintenance(type: MaintenanceType) -> Int? {
		print("daysUntilNextMaintenance appelée")
		guard let nextDate = nextMaintenanceDate(for: type) else { return nil}
		return Calendar.current.dateComponents([.day], from: Date(), to: nextDate).day
	}
	
	func nextMaintenanceDate(for type: MaintenanceType) -> Date? {
		print("nextMaintenanceDate appelée")
		guard let lastMaintenance = lastMaintenance(of: type) else { return nil }
		guard type.frequencyInDays > 0 else { return nil} // Pas de prochaine date pour Unknown
		return Calendar.current.date(byAdding: .day, value: type.frequencyInDays, to: lastMaintenance.date)
	}
	
	func lastMaintenance(of type: MaintenanceType) -> Maintenance? {
		print("lastMaintenance appelée")
		let filtered = maintenanceVM.maintenances.filter { $0.maintenanceType == type }
		return filtered.max(by: { $0.date < $1.date })
	}
	
	func fetchAllMaintenanceForOneType(type: MaintenanceType) -> [Maintenance] {
		print("fetchAllMaintenanceForOneType appelée")
		do {
			let allMaintenance = try maintenanceLoader.load()
			return allMaintenance.filter { $0.maintenanceType == type }
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
		return []
	}
}

