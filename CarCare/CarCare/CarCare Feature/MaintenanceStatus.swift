//
//  StatutEntretien.swift
//  CarCare
//
//  Created by Ordinateur elena on 16/08/2025.
//

import Foundation

enum MaintenanceStatus {
	case aJour
	case bientotAPrevoir
	case aPrevoir

	var label: String {
		switch self {
		case .aJour: return "À jour"
		case .bientotAPrevoir: return "Bientôt à prévoir"
		case .aPrevoir: return "À prévoir"
		}
	}
}
