//
//  MaintenanceStore.swift
//  CarCare
//
//  Created by Ordinateur elena on 15/07/2025.
//

import Foundation

protocol MaintenanceStore {
	func insert(_ maintenance: LocalMaintenance) throws
	func retrieve () throws -> [LocalMaintenance] 
}
