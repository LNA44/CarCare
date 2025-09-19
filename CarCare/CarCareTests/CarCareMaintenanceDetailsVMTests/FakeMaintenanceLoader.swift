//
//  FakeMaintenanceLoader.swift
//  CarCareTests
//
//  Created by Ordinateur elena on 19/09/2025.
//

import XCTest
@testable import CarCare

class FakeMaintenanceLoader4: LocalMaintenanceLoader {
	init(store: FakeMaintenanceStore4) {
		super.init(store: store)
	}
}

class FakeMaintenanceStore4: MaintenanceStore {
	var maintenances: [LocalMaintenance] = []
	var shouldThrowLoadingError = false
	var shouldThrowStoreError = false
	
	func retrieve() throws -> [LocalMaintenance] {
		if shouldThrowLoadingError { throw LoadingCocoaError.unknown }
		if shouldThrowStoreError { throw StoreError.modelNotFound }
		return maintenances
	}
	
	func insert(_ maintenance: LocalMaintenance) throws {
		if shouldThrowStoreError { throw StoreError.modelNotFound }
		maintenances.append(maintenance)
	}
	
	func update(_ maintenance: LocalMaintenance) throws {
		if let index = maintenances.firstIndex(where: { $0.id == maintenance.id }) {
			maintenances[index] = maintenance
		}
	}
	func deleteAll() throws { maintenances.removeAll() }
	func deleteOne(_ maintenance: LocalMaintenance) throws {
		maintenances.removeAll { $0.id == maintenance.id }
	}
}
