//
//  Enums.swift
//  CarCare
//
//  Created by Ordinateur elena on 15/07/2025.
//

//Vehicle
enum Brand: String, CaseIterable, Identifiable {
	case Decathlon = "Decathlon"
	case Trek = "Trek"
	case Giant = "Giant"
	case Specialized = "Specialized"
	case Cannondale = "Cannondale"
	case Moustache = "Moustache"
	case Cube = "Cube"
	case Orbea = "Orbea"
	case VanMoof = "VanMoof"
	case Gazelle = "Gazelle"
	case Unknown = "Unknown"
	
	var id: String { rawValue }
	
	var models: [String] {
		switch self {
		case .Decathlon:
			return ["Riverside 500", "Elops 520", "Elops LD 500 E", "Elops 920 E"]
		case .Trek:
			return ["FX 3 Disc", "Verve+", "Allant+ 7", "Dual Sport+ 2"]
		case .Giant:
			return ["Escape 3", "FastRoad E+", "Explore E+", "Entour E+"]
		case .Specialized:
			return ["Sirrus X", "Turbo Vado", "Turbo Como", "Alibi"]
		case .Cannondale:
			return ["Quick", "Adventure Neo", "Tesoro Neo X", "Treadwell Neo"]
		case .Moustache:
			return ["Lundi 27.1", "Friday 28.1", "Samedi 28.3", "Samedi 28.5"]
		case .Cube:
			return ["Kathmandu Hybrid", "Touring Hybrid", "Editor", "Hyde Race"]
		case .Orbea:
			return ["Optima E40", "Carpe", "Katu-E", "Vibe H30"]
		case .VanMoof:
			return ["S5", "A5", "S3", "X3"]
		case .Gazelle:
			return ["Ultimate C8+", "CityGo C7 HMS", "Paris C7 HMB", "Chamonix T10 HMB"]
		case .Unknown:
			return []
		}
	}
}

//Maintenance
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
}

//BikeType
enum BikeType: String, CaseIterable {
	case Manual = "Manual"
	case Electric = "Electric"
}
