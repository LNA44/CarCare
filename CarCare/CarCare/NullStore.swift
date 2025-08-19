//
//  NullStore.swift
//  CarCare
//
//  Created by Ordinateur elena on 22/07/2025.
//

import Foundation
//utile pour previews et catch
final class NullStore {}

extension NullStore: MaintenanceStore {
	func insert(_ maintenance: LocalMaintenance) throws {}
	func retrieve () throws -> [LocalMaintenance] { [] }
}

extension NullStore: BikeStore {
	func insert(_ bike: LocalBike) throws {}
	func retrieve () throws -> LocalBike? {nil}
	func update(_ bike: LocalBike) throws {}
}
