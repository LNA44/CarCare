//
//  MaintenanceDescription.swift
//  CarCare
//
//  Created by Ordinateur elena on 29/09/2025.
//

import Foundation

struct MaintenanceDescription {
	static let mapping: [MaintenanceType: String] = [
		.CheckTirePressure: NSLocalizedString(LocalizationKeys.checkTirePressureDescription, comment: ""),
		.ReplaceTires: NSLocalizedString(LocalizationKeys.replaceTiresDescription, comment: ""),
		.CleanAndLubricateChain: NSLocalizedString(LocalizationKeys.cleanAndLubricateChainDescription, comment: ""),
		.TightenMainScrewsAndBolts: NSLocalizedString(LocalizationKeys.tightenMainScrewsAndBoltsDescription, comment: ""),
		.CleanDrivetrain: NSLocalizedString(LocalizationKeys.cleanDrivetrainDescription, comment: ""),
		.LubricateCablesAndHousings: NSLocalizedString(LocalizationKeys.lubricateCablesAndHousingsDescription, comment: ""),
		.GreaseBottomBracket: NSLocalizedString(LocalizationKeys.greaseBottomBracketDescription, comment: ""),
		.ReplaceCablesAndHousings: NSLocalizedString(LocalizationKeys.replaceCablesAndHousingsDescription, comment: ""),
		.BleedHydraulicBrakes: NSLocalizedString(LocalizationKeys.bleedHydraulicBrakesDescription, comment: ""),
		.ServiceBearings: NSLocalizedString(LocalizationKeys.serviceBearingsDescription, comment: ""),
		.ReplaceChain: NSLocalizedString(LocalizationKeys.replaceChainDescription, comment: ""),
		.RunSoftwareAndBatteryDiagnostics: NSLocalizedString(LocalizationKeys.runSoftwareAndBatteryDiagnosticsDescription, comment: ""),
		.Unknown: NSLocalizedString(LocalizationKeys.unknownDescription, comment: "")
	]
}
