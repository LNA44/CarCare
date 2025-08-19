//
//  VehicleStore.swift
//  CarCare
//
//  Created by Ordinateur elena on 15/07/2025.
//

import Foundation

protocol BikeStore {
	func insert(_ bike: LocalBike) throws
	func retrieve () throws -> LocalBike?
	func update(_ bike: LocalBike) throws
}
