//
//  FakeMaintenanceVM.swift
//  CarCareTests
//
//  Created by Ordinateur elena on 19/09/2025.
//

import XCTest
@testable import CarCare

class FakeMaintenanceVM2: MaintenanceVM {
	var nextMaintenanceDateReturn: Date?
	override func nextMaintenanceDate(for type: MaintenanceType) -> Date? {
		return nextMaintenanceDateReturn
	}
}
