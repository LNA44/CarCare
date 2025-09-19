//
//  CarCareDashboardViewModelTests.swift
//  CarCareTests
//
//  Created by Ordinateur elena on 19/09/2025.
//

import XCTest
@testable import CarCare

final class CarCareDashboardViewModelTests: XCTestCase {
	var dashboardVM: DashboardVM!
	var maintenanceVM: FakeMaintenanceVM3!
	var store: FakeMaintenanceStore!
	var loader: FakeMaintenanceLoader!
		
	override func setUp() {
		super.setUp()
		maintenanceVM = FakeMaintenanceVM3()
		store = FakeMaintenanceStore()
		loader = FakeMaintenanceLoader(store: store)
		dashboardVM = DashboardVM(maintenanceLoader: loader, maintenanceVM: maintenanceVM)
	}
	
	override func tearDown() {
		dashboardVM = nil
		maintenanceVM = nil
		loader = nil
		store = nil
		super.tearDown()
	}
		
	func test_fetchLastMaintenance_filtersBatteryForManualBike() {
		// Given
		let batteryMaintenance = Maintenance(id: UUID(), maintenanceType: .Battery, date: Date(), reminder: false)
		let brakeMaintenance = Maintenance(id: UUID(), maintenanceType: .BrakePads, date: Date().addingTimeInterval(-1000), reminder: false)
		store.maintenances = [batteryMaintenance.toLocal(), brakeMaintenance.toLocal()]
		let expectation = XCTestExpectation(description: "Wait for async fetch")
		
		// When
		dashboardVM.fetchLastMaintenance(for: .Manual)
		
		DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
			// Then
			XCTAssertEqual(self.maintenanceVM.generalLastMaintenance?.id, brakeMaintenance.id)
			expectation.fulfill()
		}
		
		wait(for: [expectation], timeout: 1.0)
	}
	
	func test_fetchLastMaintenance_includesBatteryForElectricBike() {
		// Given
		let batteryMaintenance = Maintenance(id: UUID(), maintenanceType: .Battery, date: Date(), reminder: false)
		store.maintenances = [batteryMaintenance.toLocal()]
		let expectation = XCTestExpectation(description: "Wait for async fetch")
		
		// When
		dashboardVM.fetchLastMaintenance(for: .Electric)
		
		DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
			// Then
			XCTAssertEqual(self.maintenanceVM.generalLastMaintenance?.id, batteryMaintenance.id)
			expectation.fulfill()
		}
		
		wait(for: [expectation], timeout: 1.0)
	}
	
	func test_fetchLastMaintenance_setsLoadingCocoaError() {
		// Given
		store.shouldThrowLoadingError = true
		let expectation = XCTestExpectation(description: "Wait for error handling")
		
		// When
		dashboardVM.fetchLastMaintenance(for: .Manual)
		
		DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
			// Then
			XCTAssertNotNil(self.dashboardVM.error)
			if case .loadingDataFailed(let error) = self.dashboardVM.error {
				XCTAssertEqual(error, LoadingCocoaError.unknown)
			} else {
				XCTFail("Expected loadingDataFailed error")
			}
			XCTAssertTrue(self.dashboardVM.showAlert)
			expectation.fulfill()
		}
		
		wait(for: [expectation], timeout: 1.0)
	}
	
	func test_fetchLastMaintenance_setsStoreError() {
		// Given
		store.shouldThrowStoreError = true
		let expectation = XCTestExpectation(description: "Wait for error handling")
		
		// When
		dashboardVM.fetchLastMaintenance(for: .Manual)
		
		DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
			// Then
			XCTAssertNotNil(self.dashboardVM.error)
			if case .dataUnavailable(let error) = self.dashboardVM.error {
				XCTAssertEqual(error, StoreError.modelNotFound)
			} else {
				XCTFail("Expected dataUnavailable error")
			}
			XCTAssertTrue(self.dashboardVM.showAlert)
			expectation.fulfill()
		}
		
		wait(for: [expectation], timeout: 1.0)
	}
}
