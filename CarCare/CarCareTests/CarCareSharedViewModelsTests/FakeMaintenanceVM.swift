//
//  FakeMaintenanceVM.swift
//  CarCareTests
//
//  Created by Ordinateur elena on 18/09/2025.
//

import XCTest
@testable import CarCare

final class MaintenanceStoreFake: MaintenanceStore {
	private var storedMaintenances: [LocalMaintenance] = []
	
	func insert(_ maintenance: LocalMaintenance) throws {
		storedMaintenances.append(maintenance)
	}
	
	func retrieve() throws -> [LocalMaintenance] {
		return storedMaintenances
	}
	
	func update(_ maintenance: LocalMaintenance) throws {
		if let index = storedMaintenances.firstIndex(where: { $0.id == maintenance.id }) {
			storedMaintenances[index] = maintenance
		}
	}
	
	func deleteAll() throws {
		storedMaintenances.removeAll()
	}
	
	func deleteOne(_ maintenance: LocalMaintenance) throws {
		if let index = storedMaintenances.firstIndex(where: { $0.id == maintenance.id }) {
			storedMaintenances.remove(at: index)
		}
	}
}

final class LocalMaintenanceLoaderFake: LocalMaintenanceLoader {
	override func load() throws -> [Maintenance] {
		return [] // retourne un tableau vide pour les tests
	}
	override func update(_ maintenance: Maintenance) throws {
		// ne fait rien
	}
	override func deleteAll() throws {
		// ne fait rien
	}
	override func deleteOne(_ maintenance: Maintenance) throws {
		// ne fait rien
	}
}

final class MaintenanceVMFake: MaintenanceVM {
	init() {
		// On passe un loader factice (ou nil si on modifie le constructeur pour tests)
		super.init(loader: LocalMaintenanceLoaderFake(store: MaintenanceStoreFake()), notificationVM: nil)
	}
}	
