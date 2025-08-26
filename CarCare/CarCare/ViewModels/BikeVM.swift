//
//  BikeVM.swift
//  CarCare
//
//  Created by Ordinateur elena on 20/08/2025.
//

import Foundation

final class BikeVM: ObservableObject {
	//MARK: -Public properties
	@Published var model: String = "Unknown"
	@Published var brand: Brand = .Unknown {
		didSet {
			// Met à jour la liste des modèles et sélectionne le premier automatiquement
			models = brand.models
			model = models.first ?? ""
		}
	}
	@Published var mileage: Int = 0
	@Published var year: Int = 0
	@Published var bike: Bike? = nil {
		didSet {
			if bike != nil {
				notificationVM.checkAndScheduleNotifications()
			}
		}
	}
	@Published var models: [String] = ["Unknown"]
	@Published var bikeType: BikeType = .Manual
	@Published var identificationNumber: String = ""
	@Published var error: AppError?
	@Published var showAlert: Bool = false

	//MARK: -Private properties
	private let bikeLoader: LocalBikeLoader
	private let notificationVM: NotificationViewModel
	
	//MARK: -Initialization
	init(bikeLoader: LocalBikeLoader = DependencyContainer.shared.BikeLoader, notificationVM: NotificationViewModel) {
		self.bikeLoader = bikeLoader
		self.notificationVM = notificationVM
	}
	
	//MARK: -Methods
	func fetchBikeData() {
		do {
			guard let unwrappedBike = try bikeLoader.load() else {
				throw AppError.bikeNotFound
			}
			self.model = unwrappedBike.model
			self.brand = unwrappedBike.brand
			self.year = unwrappedBike.year
			self.identificationNumber = unwrappedBike.identificationNumber
			bike = unwrappedBike
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
	
	func modifyBikeInformations(brand: Brand, model: String, year: Int, type: BikeType, identificationNumber: String) {
		guard bike != nil else { return }
			bike!.brand = brand
			bike!.model = model
			bike!.year = year
			bike!.bikeType = type
			bike!.identificationNumber = identificationNumber
		do {
			try bikeLoader.save(bike!)
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
	
	func addBike() -> Bool {
		let bike = Bike(id: UUID(), brand: brand, model: model, year: year, bikeType: bikeType, identificationNumber: identificationNumber)
		do {
			try bikeLoader.save(bike)
			return true
		} catch let error as LoadingCocoaError { //erreurs de load
			self.error = AppError.loadingDataFailed(error)
			showAlert = true
			return false
		} catch let error as StoreError { //erreurs de CoreDataLocalStore
			self.error = AppError.dataUnavailable(error)
			showAlert = true
			return false
		} catch let error as SaveCocoaError {
			self.error = AppError.saveDataFailed(error)
			showAlert = true
			return false
		} catch {
			self.error = AppError.unknown
			showAlert = true
			return false
		}
	}
}
