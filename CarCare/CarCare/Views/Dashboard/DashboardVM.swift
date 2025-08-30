//
//  DashboardVM.swift
//  CarCare
//
//  Created by Ordinateur elena on 30/08/2025.
//

import Foundation

final class DashboardVM: ObservableObject {
	@Published var generalLastMaintenance: Maintenance? = nil
	private let maintenanceVM: MaintenanceVM
	private let maintenanceLoader: LocalMaintenanceLoader
	@Published var error: AppError?
	@Published var showAlert: Bool = false

	init(maintenanceLoader: LocalMaintenanceLoader = DependencyContainer.shared.MaintenanceLoader, maintenanceVM: MaintenanceVM) {
		self.maintenanceLoader = maintenanceLoader
		self.maintenanceVM = maintenanceVM
		}
	
	func fetchLastMaintenance() {
		print("fetchLastMaintenance appelée")
		DispatchQueue.global(qos: .userInitiated).async { //chargement hors du thread principal
			do {
				let allMaintenance = try self.maintenanceLoader.load()
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
	}
}
