//
//  BikeType.swift
//  CarCare
//
//  Created by Ordinateur elena on 20/08/2025.
//
import Foundation
enum BikeType: String, CaseIterable {
	case Manual = "manual"
	case Electric = "electric"
}

extension BikeType {
	var localizedName: String {
		NSLocalizedString(rawValue, comment: "Type of bike")
	}
}
