//
//  Maintenance.swift
//  CarCare
//
//  Created by Ordinateur elena on 15/07/2025.
//

import Foundation

struct Maintenance: Equatable, Identifiable, Hashable {
	let id: UUID
	let maintenanceType : MaintenanceType
	let date : Date
	var reminder: Bool
}
