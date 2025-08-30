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
	@Published var selectedMaintenanceType: MaintenanceType = .Unknown /*{
		didSet {
			generalLastMaintenance = maintenances
				.filter { $0.maintenanceType == selectedMaintenanceType }
				.max(by: { $0.date < $1.date })
			generalLastMaintenance = nil
		}
	}*/
	@Published var selectedMaintenanceDate: Date? /*{
		didSet {
				generalLastMaintenance = maintenances
					.filter { $0.maintenanceType == selectedMaintenanceType }
					.max(by: { $0.date < $1.date })
				generalLastMaintenance = nil
		}
	}*/
	
	init(maintenanceLoader: LocalMaintenanceLoader = DependencyContainer.shared.MaintenanceLoader, maintenanceVM: MaintenanceVM) {
		self.maintenanceLoader = maintenanceLoader
		self.maintenanceVM = maintenanceVM
	}
	
	func addMaintenance() {
		if let selectedMaintenanceDate = selectedMaintenanceDate {
			print("addMaintenance appelée")
			let maintenance = Maintenance(id: UUID(), maintenanceType: selectedMaintenanceType, date: selectedMaintenanceDate, reminder: true)
			do {
				try maintenanceLoader.save(maintenance)
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
		}
	}
}
