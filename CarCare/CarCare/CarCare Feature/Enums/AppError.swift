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
	
}

extension AppError {
	var localizedDescription: String {
		switch self {
		case .bikeLoadFailed(_):
			return NSLocalizedString("bike_load_failed", comment: "Error occurred while loading the bike") //fait appel à la trad en plsrs langues
		case .dataUnavailable(_):
			return NSLocalizedString("data_unavailable", comment: "Data unavailable")
		case .loadingDataFailed(let cocoaError):
			let format = NSLocalizedString("loading_data_failed", comment: "Error occurred while loading data")
			return String(format: format, cocoaError.localizedDescription)
		case .fetchDataFailed(let fetchCocoaError):
			let format = NSLocalizedString("fetch_data_failed", comment: "Error occurred while fetching data")
			return String(format: format, fetchCocoaError.localizedDescription)
		case .saveDataFailed(let saveCocoaError):
			let format = NSLocalizedString("save_data_failed", comment: "Error occurred while saving data")
			return String(format: format, saveCocoaError.localizedDescription)
		case .notificationError(_):
			return NSLocalizedString("notification_error", comment: "Error occurred while sending notification")
		case .notificationNotAuthorized:
			return NSLocalizedString("notification_not_authorized", comment: "Notifications not authorized")
		case .bikeNotFound:
			return NSLocalizedString("bike_not_found", comment: "Bike not found")
		case .unknown:
			return NSLocalizedString("unknown_error_message", comment: "Unexpected error occurred")
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

