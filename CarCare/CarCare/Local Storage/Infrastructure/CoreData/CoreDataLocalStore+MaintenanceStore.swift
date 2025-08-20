//
//  CoreDataLocalStore+MaintenanceStore.swift
//  CarCare
//
//  Created by Ordinateur elena on 15/07/2025.
//

import CoreData

extension CoreDataLocalStore: MaintenanceStore {
	func insert(_ maintenance: LocalMaintenance) throws {
		try performSync { context in
			Result {
				try ManagedMaintenance.new(from: maintenance, in: context)
			}
		}
	}
	
	func retrieve () throws -> [LocalMaintenance] {
		try performSync { context in
			Result {
				try ManagedMaintenance.findAll(in: context)
					.map { $0.local } //convertit chaque ManagedMaintenance en LocalMaintenance
			}
		}
	}
	
	func update(_ maintenance: LocalMaintenance) throws {
		try performSync { context in
			Result {
				try ManagedMaintenance.update(from: maintenance, in: context)
			}
		}
	}
}
