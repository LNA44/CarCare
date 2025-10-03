//
//  Bike_Enum.swift
//  CarCare
//
//  Created by Ordinateur elena on 20/08/2025.
//

import Foundation

enum Brand: String, CaseIterable, Identifiable {
        case ants11 = "11ANTS"
        case brand13 = "13"
        case bikes18 = "18 Bikes"
        case oneOfOne = "1of1"
        case oneUp = "1up"
        case cycles2_11 = "2-11 Cycles"
        case year2019 = "2019"
        case line3 = "3 Line"
        case fab333 = "333 Fab"
        case line3Alt = "3Line"
        case t3 = "3T"
        case t3Cycling = "3T Cycling"
        case t3Lower = "3t"
        case fourBro = "4BRO"
        case fourE = "4E"
        case fourLeaf = "4Leaf"
        case fourEver = "4ever"
        case cycles509 = "509 Cycles"
        case x58 = "58 x 58"
        case ku6 = "6KU"
        case bar8 = "8bar"
        case n99 = "99"
        case zero7 = "9:Zero:7"
        case unknownSymbol = "?"
        case aDBikes = "A-D Bikes"
        case aFrameCycles = "A-Frame Cycles"
        case aBike = "A-bike"
        case a2 = "A2"
        case aXUS = "A:XUS"
        case aa = "AA"
        case adr = "ADR"
        case am = "AM"
        case araya = "ARAYA"
        case arbr = "ARBR"
        case argon18 = "ARGON 18"
        case army = "ARMY"
        case aster = "ASTER"
        case atr = "ATR"
        case axLightness = "AX Lightness"
        case abici = "Abici"
        case absolute = "Absolute"
        case academy = "Academy"
        case accent = "Accent"
        case access = "Access"
        case accolmile = "Accolmile"
        case acelane = "Acelane"
        case acol = "Acol"
        case actico = "Actico"
        case active = "Active"
        case actofive = "Actofive"
        case addmotor = "Addmotor"
        case adriatica = "Adriatica"
        case adris = "Adris"
        case adrisSports = "Adris Sports"
        case advanced = "Advanced"
        case advancedMountain = "Advanced Mountain"
        case advocate = "Advocate"
        case aeroCat = "AeroCat"
        case affinity = "Affinity"
        case agazzini = "Agazzini"
        case agostino = "Agostino"
        case airborne = "Airborne"
        case airdrop = "Airdrop"
        case Unknown = "Unknown"
	
	var id: String { rawValue }
	
	var models: [String] {
		switch self {
        case .ants11: return ["Model 1", "Model 2", "Model 3", "Model 4"]
        case .brand13: return ["Model 1", "Model 2", "Model 3", "Model 4"]
        case .bikes18: return ["Model 1", "Model 2", "Model 3", "Model 4"]
        case .oneOfOne: return ["Model 1", "Model 2", "Model 3", "Model 4"]
        case .oneUp: return ["Model 1", "Model 2", "Model 3", "Model 4"]
        case .cycles2_11: return ["Model 1", "Model 2", "Model 3", "Model 4"]
        case .year2019: return ["Model 1", "Model 2", "Model 3", "Model 4"]
        case .line3: return ["Model 1", "Model 2", "Model 3", "Model 4"]
        case .fab333: return ["Model 1", "Model 2", "Model 3", "Model 4"]
        case .line3Alt: return ["Model 1", "Model 2", "Model 3", "Model 4"]
        case .t3: return ["Model 1", "Model 2", "Model 3", "Model 4"]
        case .t3Cycling: return ["Model 1", "Model 2", "Model 3", "Model 4"]
        case .t3Lower: return ["Model 1", "Model 2", "Model 3", "Model 4"]
        case .fourBro: return ["Model 1", "Model 2", "Model 3", "Model 4"]
        case .fourE: return ["Model 1", "Model 2", "Model 3", "Model 4"]
        case .fourLeaf: return ["Model 1", "Model 2", "Model 3", "Model 4"]
        case .fourEver: return ["Model 1", "Model 2", "Model 3", "Model 4"]
        case .cycles509: return ["Model 1", "Model 2", "Model 3", "Model 4"]
        case .x58: return ["Model 1", "Model 2", "Model 3", "Model 4"]
        case .ku6: return ["Model 1", "Model 2", "Model 3", "Model 4"]
        case .bar8: return ["Model 1", "Model 2", "Model 3", "Model 4"]
        case .n99: return ["Model 1", "Model 2", "Model 3", "Model 4"]
        case .zero7: return ["Model 1", "Model 2", "Model 3", "Model 4"]
        case .unknownSymbol: return ["Model 1", "Model 2", "Model 3", "Model 4"]
        case .aDBikes: return ["Model 1", "Model 2", "Model 3", "Model 4"]
        case .aFrameCycles: return ["Model 1", "Model 2", "Model 3", "Model 4"]
        case .aBike: return ["Model 1", "Model 2", "Model 3", "Model 4"]
        case .a2: return ["Model 1", "Model 2", "Model 3", "Model 4"]
        case .aXUS: return ["Model 1", "Model 2", "Model 3", "Model 4"]
        case .aa: return ["Model 1", "Model 2", "Model 3", "Model 4"]
        case .adr: return ["Model 1", "Model 2", "Model 3", "Model 4"]
        case .am: return ["Model 1", "Model 2", "Model 3", "Model 4"]
        case .araya: return ["Model 1", "Model 2", "Model 3", "Model 4"]
        case .arbr: return ["Model 1", "Model 2", "Model 3", "Model 4"]
        case .argon18: return ["Model 1", "Model 2", "Model 3", "Model 4"]
        case .army: return ["Model 1", "Model 2", "Model 3", "Model 4"]
        case .aster: return ["Model 1", "Model 2", "Model 3", "Model 4"]
        case .atr: return ["Model 1", "Model 2", "Model 3", "Model 4"]
        case .axLightness: return ["Model 1", "Model 2", "Model 3", "Model 4"]
        case .abici: return ["Model 1", "Model 2", "Model 3", "Model 4"]
        case .absolute: return ["Model 1", "Model 2", "Model 3", "Model 4"]
        case .academy: return ["Model 1", "Model 2", "Model 3", "Model 4"]
        case .accent: return ["Model 1", "Model 2", "Model 3", "Model 4"]
        case .access: return ["Model 1", "Model 2", "Model 3", "Model 4"]
        case .accolmile: return ["Model 1", "Model 2", "Model 3", "Model 4"]
        case .acelane: return ["Model 1", "Model 2", "Model 3", "Model 4"]
        case .acol: return ["Model 1", "Model 2", "Model 3", "Model 4"]
        case .actico: return ["Model 1", "Model 2", "Model 3", "Model 4"]
        case .active: return ["Model 1", "Model 2", "Model 3", "Model 4"]
        case .actofive: return ["Model 1", "Model 2", "Model 3", "Model 4"]
        case .addmotor: return ["Model 1", "Model 2", "Model 3", "Model 4"]
        case .adriatica: return ["Model 1", "Model 2", "Model 3", "Model 4"]
        case .adris: return ["Model 1", "Model 2", "Model 3", "Model 4"]
        case .adrisSports: return ["Model 1", "Model 2", "Model 3", "Model 4"]
        case .advanced: return ["Model 1", "Model 2", "Model 3", "Model 4"]
        case .advancedMountain: return ["Model 1", "Model 2", "Model 3", "Model 4"]
        case .advocate: return ["Model 1", "Model 2", "Model 3", "Model 4"]
        case .aeroCat: return ["Model 1", "Model 2", "Model 3", "Model 4"]
        case .affinity: return ["Model 1", "Model 2", "Model 3", "Model 4"]
        case .agazzini: return ["Model 1", "Model 2", "Model 3", "Model 4"]
        case .agostino: return ["Model 1", "Model 2", "Model 3", "Model 4"]
        case .airborne: return ["Model 1", "Model 2", "Model 3", "Model 4"]
        case .airdrop: return ["Model 1", "Model 2", "Model 3", "Model 4"]
        case .Unknown: return []
        }
    }
    
    var localizedName: String {
        NSLocalizedString(rawValue, comment: "Brand name")
    }
}
