//
//  MaintenanceType.swift
//  CarCare
//
//  Created by Ordinateur elena on 20/08/2025.
//
import Foundation

enum MaintenanceType: String, CaseIterable, Identifiable {
	var id: String { rawValue }
	
	case Tires = "tires"
	case BrakePads = "brake_pads"
	case Battery = "battery"
	case Unknown = "unknown"
	
	var frequencyInDays: Int {
		switch self { // A ADAPTER
		case .Tires: return 7       // 1 semaine
		case .BrakePads: return 7      // 1 semaine
		case .Battery: return 30     // 1 mois
		case .Unknown: return 0
		}
	}
	
	var iconName: String {
			switch self {
			case .Tires: return "wheels"
			case .BrakePads: return "brake-pad"
			case .Battery: return "battery"
			case .Unknown: return "questionmark.circle"   
			}
		}
}

extension MaintenanceType: Hashable {
	var readableFrequency: String {
		if frequencyInDays < 30 {
			return String(format: NSLocalizedString("every_days_key", comment: ""), frequencyInDays)
		} else {
			let months = frequencyInDays / 30
			return String(format: NSLocalizedString("every_months_key", comment: ""), months)
		}
	}
	
	var localizedName: String {
		NSLocalizedString(rawValue, comment: "")
	}
	
	var localizedDescription: String {
		switch self {
		case .Tires:
			return NSLocalizedString("tires_description", comment: "Description for tire maintenance")
		case .BrakePads:
			return NSLocalizedString("brake_pads_description", comment: "Description for brake pads maintenance")
		case .Battery:
			return NSLocalizedString("battery_description", comment: "Description for battery maintenance")
		case .Unknown:
			return NSLocalizedString("unknown_description", comment: "Description for unknown maintenance")
		}
	}
}

extension MaintenanceType {
	init(fromCoreDataString string: String) {
		switch string {
		// FR
		case "Pneus": self = .Tires
		case "Plaquettes de frein": self = .BrakePads
		case "Batterie": self = .Battery
		// ES
		case "Neumáticos": self = .Tires
		case "Pastillas de freno": self = .BrakePads
		case "Batería": self = .Battery
		// EN
		case "Tires": self = .Tires
		case "Brakepads": self = .BrakePads
		case "Battery": self = .Battery
		default: self = .Unknown
		}
	}
}
