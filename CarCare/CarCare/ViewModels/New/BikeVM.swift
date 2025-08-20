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
	@Published var brand: Brand = .Unknown {
		didSet {
			// Met à jour la liste des modèles et sélectionne le premier automatiquement
			models = brand.models
			model = models.first ?? ""
		}
	}
	@Published var mileage: Int = 0
	@Published var year: Int = 0
	@Published var bike: Bike? = nil
	@Published var models: [String] = []
	@Published var bikeType: BikeType = .Manual

	//MARK: -Private properties
	private let bikeLoader: LocalBikeLoader
	
	//MARK: -Initialization
	init(bikeLoader: LocalBikeLoader = DependencyContainer.shared.BikeLoader) {
		self.bikeLoader = bikeLoader
	}
	
	//MARK: -Methods
	func fetchBikeData() {
		do {
			guard let unwrappedBike = try bikeLoader.load() else {
				print("problème de chargement du vélo")
				return
			}
			self.model = unwrappedBike.model
			self.brand = unwrappedBike.brand
			self.year = unwrappedBike.year
			bike = unwrappedBike
		} catch {
			print("erreur dans le chargement du vélo")
		}
	}
	
	func modifyBikeInformations(brand: Brand, model: String, year: Int, type: BikeType) {
		guard bike != nil else { return }
			bike!.brand = brand
			bike!.model = model
			bike!.year = year
			bike!.bikeType = type
		do {
			try bikeLoader.save(bike!)
		} catch {
			print("erreur lors de la modification du vélo")
		}
	}
	
	func addBike() -> Bool {
		let bike = Bike(id: UUID(), brand: brand, model: model, year: year, bikeType: bikeType)
		do {
			try bikeLoader.save(bike)
			print("Vélo sauvegardé avec succès")
			return true
		} catch {
			print("Erreur lors de la sauvegarde")
			return false
		}
	}
}
