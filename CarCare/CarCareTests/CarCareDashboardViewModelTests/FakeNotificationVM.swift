//
//  FakeNotificationVM.swift
//  CarCareTests
//
//  Created by Ordinateur elena on 19/09/2025.
//

import XCTest
@testable import CarCare

class FakeNotificationVM: NotificationViewModel {
		var scheduledNotifications: [(MaintenanceType, Date)] = []

		override func scheduleNotifications(for type: MaintenanceType, until endDate: Date) {
			scheduledNotifications.append((type, endDate))
		}
	}
