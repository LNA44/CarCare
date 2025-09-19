//
//  CarCareAddMaintenanceVMTests.swift
//  CarCareTests
//
//  Created by Ordinateur elena on 19/09/2025.
//

import XCTest
@testable import CarCare

final class AddMaintenanceVMTests: XCTestCase {
	var addVM: AddMaintenanceVM!
		var maintenanceVM: FakeMaintenanceVM3!
		var store: FakeMaintenanceStore!
		var loader: FakeMaintenanceLoader!
		var notificationVM: FakeNotificationVM!

		override func setUp() {
			super.setUp()
			maintenanceVM = FakeMaintenanceVM3()
			store = FakeMaintenanceStore()
			loader = FakeMaintenanceLoader(store: store)
			notificationVM = FakeNotificationVM(maintenanceVM: maintenanceVM)
			addVM = AddMaintenanceVM(maintenanceLoader: loader, maintenanceVM: maintenanceVM, notificationVM: notificationVM)
		}

		override func tearDown() {
			addVM = nil
			maintenanceVM = nil
			store = nil
			loader = nil
			notificationVM = nil
			super.tearDown()
		}

	func test_addMaintenance_savesMaintenanceAndFetchesAll() {
		// Given
		addVM.selectedMaintenanceType = .BrakePads
		let bikeType: BikeType = .Manual
		let selectedDate = Date()
		addVM.selectedMaintenanceDate = selectedDate
		
		// When
		addVM.addMaintenance(bikeType: bikeType)
		
		// Then
		let expectation = XCTestExpectation(description: "Wait for fetchAllMaintenance")
		DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
			XCTAssertFalse(self.maintenanceVM.maintenances.isEmpty)
			expectation.fulfill()
		}
		wait(for: [expectation], timeout: 1.0)
		XCTAssertEqual(store.maintenances.count, 1)
		XCTAssertEqual(notificationVM.scheduledNotifications.count, 1)
		XCTAssertEqual(notificationVM.scheduledNotifications.first?.0, .BrakePads)
	}
	
	func test_addMaintenance_handlesStoreError() {
		// Given
		store.shouldThrowStoreError = true
		addVM.selectedMaintenanceType = .BrakePads
		addVM.selectedMaintenanceDate = Date()

		let expectation = XCTestExpectation(description: "Wait for addMaintenance error handling")

		// When
		addVM.addMaintenance(bikeType: .Manual)

		// Then
		DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
			XCTAssertNotNil(self.addVM.error)
			if case .dataUnavailable(let error) = self.addVM.error {
				// On vérifie que l'erreur correspond bien au type StoreError simulé
				if case .modelNotFound = error {
					// succès
				} else {
					XCTFail("Expected StoreError.modelNotFound")
				}
			} else {
				XCTFail("Expected dataUnavailable error")
			}
			XCTAssertTrue(self.addVM.showAlert)
			expectation.fulfill()
		}

		wait(for: [expectation], timeout: 1.0)
	}
	
	func test_filteredMaintenanceTypes_excludesBatteryForManual() {
		// When
		let types = addVM.filteredMaintenanceTypes(for: .Manual)
		// Then
		XCTAssertFalse(types.contains(.Battery))
	}
	
	func test_filteredMaintenanceTypes_includesBatteryForElectric() {
		// When
		let types = addVM.filteredMaintenanceTypes(for: .Electric)
		// Then
		XCTAssertTrue(types.contains(.Battery))
	}
	
	func test_nextMaintenanceDate_returnsCorrectDate() {
		// Given
		let lastDate = Date()
		let maintenance = Maintenance(id: UUID(), maintenanceType: .BrakePads, date: lastDate, reminder: true)
		maintenanceVM.maintenances = [maintenance]
		
		// When
		let nextDate = addVM.nextMaintenanceDate(for: .BrakePads)
		
		// Then
		let expected = Calendar.current.date(byAdding: .day, value: MaintenanceType.BrakePads.frequencyInDays, to: lastDate)
		XCTAssertEqual(nextDate, expected)
	}
	
	func test_daysUntilNextMaintenance_returnsCorrectDays() {
		// Given
		let lastDate = Date()
		let maintenance = Maintenance(id: UUID(), maintenanceType: .BrakePads, date: lastDate, reminder: true)
		maintenanceVM.maintenances = [maintenance]
		
		// When
		let days = addVM.daysUntilNextMaintenance(type: .BrakePads)
		
		// Then
		let expectedDate = Calendar.current.date(byAdding: .day, value: MaintenanceType.BrakePads.frequencyInDays, to: lastDate)!
		let expectedDays = Calendar.current.dateComponents([.day], from: Date(), to: expectedDate).day
		XCTAssertEqual(days, expectedDays)
	}
}
