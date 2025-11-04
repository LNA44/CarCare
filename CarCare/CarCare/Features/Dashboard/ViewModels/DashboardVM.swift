//
//  DashboardVM.swift
//  CarCare
//
//  Created by Ordinateur elena on 30/08/2025.
//

import Foundation

final class DashboardVM: ObservableObject {
	private let maintenanceVM: MaintenanceVM
    private let bikeVM: BikeVM
	private let maintenanceLoader: LocalMaintenanceLoader
	@Published var error: AppError?
	@Published var showAlert: Bool = false

    init(maintenanceLoader: LocalMaintenanceLoader = DependencyContainer.shared.MaintenanceLoader, maintenanceVM: MaintenanceVM, bikeVM: BikeVM) {
		self.maintenanceLoader = maintenanceLoader
		self.maintenanceVM = maintenanceVM
        self.bikeVM = bikeVM
		}
	
	func fetchLastMaintenance(for bikeType: BikeType) {
		DispatchQueue.global(qos: .userInitiated).async { //chargement hors du thread principal
			do {
				let allMaintenance = try self.maintenanceLoader.load()
				
				// Filtrage : on ignore les batteries pour les vélos manuels
				let filtered: [Maintenance]
				if bikeType == .Manual {
					filtered = allMaintenance.filter { $0.maintenanceType != .RunSoftwareAndBatteryDiagnostics }
				} else {
					filtered = allMaintenance
				}
				
				let sortedMaintenance = filtered
					.sorted { $0.date > $1.date } //tri décroissant
				DispatchQueue.main.async {
					self.maintenanceVM.generalLastMaintenance = sortedMaintenance.first
				}
			} catch let error as LoadingCocoaError { //erreurs de load
				DispatchQueue.main.async {
					self.error = AppError.loadingDataFailed(error)
					self.showAlert = true
				}
			} catch let error as StoreError { //erreurs de CoreDataManager
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
    
    func exportPDF(maintenances: [Maintenance]) {
        guard let bike = bikeVM.bike else {
            self.error = AppError.bikeNotFound
            self.showAlert = true
            return
        }
        do {
            try ExportPDFHelper().sharePDF(bike: bike, from: maintenances)

        } catch let pdfError as PDFError {
            self.error = .pdfError(pdfError) // AppError.pdfError(PDFError)
            self.showAlert = true
        } catch {
            self.error = .unknown
            self.showAlert = true
        }
    }
}
