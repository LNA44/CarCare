//
//  AppError.swift
//  CarCare
//
//  Created by Ordinateur elena on 25/08/2025.
//

import Foundation

enum AppError: Error, LocalizedError {
	// Erreurs liées aux données
	case bikeLoadFailed(Error) // erreur du AppState
	case dataUnavailable(StoreError) //mapping des erreurs StoreError pour que les erreurs soient compréhensibles par l'utilisateur
	case loadingDataFailed(LoadingCocoaError) //mapping des erreurs CocoaError pour que les erreurs soient compréhensibles par l'utilisateur
	case fetchDataFailed(FetchCocoaError)
	case saveDataFailed(SaveCocoaError)
	
	//Erreurs liées aux notifications
	case notificationError(Error)
	case notificationNotAuthorized
	
	case bikeNotFound
	case unknown
	
	var errorDescription: String? {
		switch self {
		case .bikeLoadFailed(_): return "Une erreur est survenue lors du chargement du vélo."
		case .dataUnavailable(let storeError): return "Vos données ne sont pas disponibles."
		case .loadingDataFailed(let cocoaError): return "Erreur lors du chargement des données : \(cocoaError.localizedDescription)."
		case .fetchDataFailed(let fetchCocoaError): return "Erreur lors du chargement des données : \(fetchCocoaError.localizedDescription)."
		case .saveDataFailed(let saveCocoaError): return "Erreur lors de la sauvegarde des données : \(saveCocoaError.localizedDescription)."
		case .notificationError: return "Une erreur est survenue lors de l'envoi de la notification."
		case .notificationNotAuthorized: return "Les notifications ne sont pas autorisées."
		case .bikeNotFound: return "Le vélo n'a pas été trouvé."
		case .unknown: return "Une erreur inattendue est survenue."
		}
	}
}

enum StoreError: Error { //CoreData
	case modelNotFound
	case failedToLoadPersistentContainer(Error)
}

enum LoadingCocoaError: Error {
	case migrationNeeded       // persistentStoreIncompatibleVersionHash / persistentStoreIncompatibleSchema
	case storeOpenFailed       // persistentStoreOpen, persistentStoreTimeout
	case saveFailed            // persistentStoreSave, persistentStoreSaveConflicts
	case validationFailed      // validationMissingMandatoryProperty, validationNumberTooLarge, etc.
	case unknown               // toutes les autres erreurs
}

enum FetchCocoaError: Error {
	case storeOpenFailed       // persistentStoreOpen, persistentStoreTimeout
	case unknown
}

enum SaveCocoaError: Error {
	case saveFailed            // persistentStoreSave, persistentStoreSaveConflicts
	case validationFailed      // validationMissingMandatoryProperty, validationNumberTooLarge/TooSmall, validationStringTooLong/TooShort
	case unknown               // toutes les autres erreurs liées au save
}
