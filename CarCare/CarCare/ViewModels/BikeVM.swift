//
//  BikeVM.swift
//  CarCare
//
//  Created by Ordinateur elena on 20/08/2025.
//

import Foundation

final class BikeVM: ObservableObject {
	//MARK: -Public properties
	@Published var model: String = ""
	@Published var brand: Brand = .Unknown
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
	//synchronise bike et les published
	func fetchBikeData() {
		print("fetchBikeData appelée")
		DispatchQueue.global(qos: .userInitiated).async { //charge en arrière plan donc ne bloque pas l'UI
			do {
				guard let unwrappedBike = try self.bikeLoader.load() else {
					throw AppError.bikeNotFound
				}
				DispatchQueue.main.async { // tout mettre à jour en une fois pour éviter création de la vue plusieurs fois
					self.model = unwrappedBike.model
					self.brand = unwrappedBike.brand
					self.year = unwrappedBike.year
					self.identificationNumber = unwrappedBike.identificationNumber
					self.bike = unwrappedBike
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
	
	func modifyBikeInformations(brand: Brand, model: String, year: Int, type: BikeType, identificationNumber: String) {
		print("modifyBikeInformations appelée")
		guard bike != nil else { return }
			bike!.brand = brand
			bike!.model = model
			bike!.year = year
			bike!.bikeType = type
			bike!.identificationNumber = identificationNumber
		//met à jour les published après modif
		self.brand = brand
		self.model = model
		self.year = year
		self.bikeType = type
		self.identificationNumber = identificationNumber
		
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
	
	func addBike(brand: Brand, model: String, year: Int, type: BikeType, identificationNumber: String) -> Bool {
		print("addBike appelée")
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
