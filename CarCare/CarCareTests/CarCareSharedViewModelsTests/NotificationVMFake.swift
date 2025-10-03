//
//  NotificationVMFake.swift
//  CarCareTests
//
//  Created by Ordinateur elena on 18/09/2025.
//

import XCTest
@testable import CarCare

final class NotificationVMFake: NotificationViewModel {
	init() {
		let maintenanceVM = MaintenanceVMFake()
		super.init(maintenanceVM: maintenanceVM)
	}
}
