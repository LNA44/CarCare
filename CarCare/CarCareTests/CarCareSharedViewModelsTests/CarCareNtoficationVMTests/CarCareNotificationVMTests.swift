//
//  CarCareNotificationVMTests.swift
//  CarCareTests
//
//  Created by Ordinateur elena on 19/09/2025.
//

import XCTest
@testable import CarCare

final class CarCareNotificationVMTests: XCTestCase {
	var notificationCenter: FakeNotificationCenter!
	var maintenanceVM: FakeMaintenanceVM2!
	
	override func setUp() {
		super.setUp()
		notificationCenter = FakeNotificationCenter()
		maintenanceVM = FakeMaintenanceVM2()
	}
	
	override func tearDown() {
		notificationCenter = nil
		maintenanceVM = nil
		super.tearDown()
	}
	
	func test_updateReminder_schedulesNotification_ifAuthorizedAndNextDateWithin30Days() {
		// Given
        let maintenance = Maintenance(id: UUID(), maintenanceType: .BleedHydraulicBrakes, date: Date(), reminder: false)
		maintenanceVM.maintenances = [maintenance]
		maintenanceVM.nextMaintenanceDateReturn = Date().addingTimeInterval(5*24*3600) // 5 jours
		
		let vm = NotificationViewModel(maintenanceVM: maintenanceVM, notificationCenter: notificationCenter)
		vm.isAuthorized = true
		
		// When
		vm.updateReminder(for: maintenance.id, value: true)
		
		// Then
		XCTAssertEqual(notificationCenter.addedRequests.count, 1)
		XCTAssertEqual(notificationCenter.addedRequests.first?.identifier, maintenance.maintenanceType.id)
	}
	
	func test_updateReminder_cancelsNotification_ifValueIsFalse() {
		// Given
		let maintenance = Maintenance(id: UUID(), maintenanceType: .BleedHydraulicBrakes, date: Date(), reminder: false)
		maintenanceVM.maintenances = [maintenance]
		
		let vm = NotificationViewModel(maintenanceVM: maintenanceVM, notificationCenter: notificationCenter)
		
		// When
		vm.updateReminder(for: maintenance.id, value: false)
		
		// Then
		XCTAssertEqual(notificationCenter.removedIdentifiers.first, maintenance.maintenanceType.id)
	}
	
	func test_requestAndScheduleNotifications_setsIsAuthorized() async {
		// Given
		notificationCenter.granted = true
		
		let vm = NotificationViewModel(maintenanceVM: maintenanceVM, notificationCenter: notificationCenter)
		
		// When
		await vm.requestAndScheduleNotifications()
		
		// Then
		XCTAssertTrue(vm.isAuthorized)
		XCTAssertTrue(notificationCenter.requestAuthorizationCalled)
	}
	
	func test_requestAndScheduleNotifications_setsIsAuthorizedFalse_whenDenied() async {
		// Given
		notificationCenter.granted = false
		
		let vm = NotificationViewModel(maintenanceVM: maintenanceVM, notificationCenter: notificationCenter)
		
		// When
		await vm.requestAndScheduleNotifications()
		
		// Then
		XCTAssertFalse(vm.isAuthorized)
	}
	
}
