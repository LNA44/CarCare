//
//  AppError.swift
//  CarCare
//
//  Created by Ordinateur elena on 25/08/2025.
//

import Foundation

enum AppError: Error, LocalizedError {
	// Erreurs liées aux données
	/*case dataNotFound
	case invalidData
	case decodeFailed(Error)
	case persistenceError(Error)*/
	
	//Erreurs liées aux notifications
	case notificationError(Error)
	case notificationNotAuthorized

	// Erreurs métiers
	//case bikeNotRegistered
	//case maintenanceAlreadyExists

	// Description utilisateur
	/*var errorDescription: String? {
		switch self {
		case .dataNotFound: return "Aucune donnée trouvée."
		case .invalidData: return "Données invalides."
		case .decodeFailed(let error): return "Échec du décodage : \(error.localizedDescription)"
		case .persistenceError(let error): return "Erreur de sauvegarde : \(error.localizedDescription)"
		case .networkError(let error): return "Erreur réseau : \(error.localizedDescription)"
		case .bikeNotRegistered: return "Votre vélo n'est pas enregistré."
		case .maintenanceAlreadyExists: return "Cette maintenance existe déjà."
		case .notificationNotAuthorized: return "Les notifications ne sont pas autorisées."
		}
	}*/
}
