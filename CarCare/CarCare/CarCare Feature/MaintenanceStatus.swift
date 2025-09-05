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
			case .aJour:
				return NSLocalizedString("maintenance_up_to_date", comment: "Maintenance is up to date")
			case .bientotAPrevoir:
				return NSLocalizedString("maintenance_soon_due", comment: "Maintenance soon to be planned")
			case .aPrevoir:
				return NSLocalizedString("maintenance_due", comment: "Maintenance to be planned")
			}
		}
}
