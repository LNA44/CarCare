//
//  RegistrationVM.swift
//  CarCare
//
//  Created by Ordinateur elena on 22/07/2025.
//

import Foundation

final class RegistrationVM: ObservableObject {
	//MARK: -Public properties
	@Published var brand: Brand = .Decathlon {
		didSet {
			// Met à jour la liste des modèles et sélectionne le premier automatiquement
			models = brand.models
			model = models.first ?? ""
		}
	}
	@Published var models: [String]
	@Published var model: String
	@Published var year: String = ""
	@Published var bikeType: BikeType = .Manual
	@Published var shouldNavigate = false
	
	//MARK: -Private properties
	private let loader: LocalBikeLoader
	
	//MARK: -Initialization
	init(loader: LocalBikeLoader = DependencyContainer.shared.BikeLoader) {
		self.loader = loader
		let initialModels = Brand.Decathlon.models
		self.models = initialModels
		self.model = initialModels.first ?? ""
	}
	
	//MARK: -Methods
	func addVehicle() {
		guard let yearInt = Int(year) else {
			print("Année ou kilométrage invalides")
			return
		}
		let vehicle = Bike(id: UUID(), brand: brand, model: model, year: yearInt, bikeType: bikeType)
		do {
			try loader.save(vehicle)
			print("Vélo sauvegardé avec succès")
			shouldNavigate = true
	} catch {
		print("Erreur lors de la sauvegarde")
		}
	}
}
