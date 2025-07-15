//
//  FuelRefillStore.swift
//  CarCare
//
//  Created by Ordinateur elena on 15/07/2025.
//

import Foundation

protocol FuelRefillStore {
	func insert(_ fuelRefill: LocalFuelRefill) throws
	func retrieve () throws -> [LocalFuelRefill]
}
