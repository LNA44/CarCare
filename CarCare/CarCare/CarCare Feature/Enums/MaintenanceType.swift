//
//  MaintenanceType.swift
//  CarCare
//
//  Created by Ordinateur elena on 20/08/2025.
//

enum MaintenanceType: String, CaseIterable, Identifiable {
	var id: String { rawValue }
	
	case Tires = "Pneus" // A ADAPTER
	case BrakePads = "Plaquettes de frein"
	case Battery = "Batterie"
	case Unknown = "Inconnu"
	
	var frequencyInDays: Int {
		switch self { // A ADAPTER
		case .Tires: return 7       // 1 semaine
		case .BrakePads: return 7      // 1 semaine
		case .Battery: return 30     // 1 mois
		case .Unknown: return 0
		}
	}
	
	var description: String {
		switch self {
		case .Tires:
			return """
	Le nettoyage de base consiste à :
	- Nettoyer le cadre avec un chiffon humide
	- Vérifier l'état des pneus
	- Contrôler la pression
	"""
		case .BrakePads:
			return """
	Le réglage des freins nécessite des outils 
	"""
		case .Battery:
			return """
	  L'entretien de la chaîne comprend :
	  - Nettoyage avec un dégraissant
	  - Lubrification des maillons
	  - Vérification de l'usure
	  """
		case .Unknown:
			return "Unknown"
		}
	}
}

extension MaintenanceType: Hashable {
	var readableFrequency: String {
		if frequencyInDays < 30 {
			return "tous les \(frequencyInDays) jour\(frequencyInDays > 1 ? "s" : "")"
		} else {
			let months = frequencyInDays / 30
			return "tous les \(months) mois"
		}
	}
}
