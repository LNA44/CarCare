//
//  CarCareAddMaintenanceVMTests.swift
//  CarCareTests
//
//  Created by Ordinateur elena on 19/09/2025.
//

import XCTest
@testable import CarCare

final class CarCareAddMaintenanceDetailsVMTests: XCTestCase {
	var maintenanceVM: MaintenanceVM!
	var store: FakeMaintenanceStore4!
	var loader: FakeMaintenanceLoader4!
	var vm: MaintenanceDetailsVM!
	
	override func setUp() {
		super.setUp()
		store = FakeMaintenanceStore4()
		loader = FakeMaintenanceLoader4(store: store)
		maintenanceVM = MaintenanceVM(loader: loader)
		vm = MaintenanceDetailsVM(maintenanceLoader: loader, maintenanceVM: maintenanceVM)
	}
	
	override func tearDown() {
		vm = nil
		loader = nil
		maintenanceVM = nil
		store = nil
		super.tearDown()
	}
	
	func test_lastMaintenance_returnsCorrectMaintenance() {
		// Given
		let oldMaintenance = Maintenance(id: UUID(), maintenanceType: .BleedHydraulicBrakes, date: Date().addingTimeInterval(-3600), reminder: true)
		let recentMaintenance = Maintenance(id: UUID(), maintenanceType: .BleedHydraulicBrakes, date: Date(), reminder: true)
		maintenanceVM.maintenances = [oldMaintenance, recentMaintenance]
		
		// When
		let last = vm.getLastMaintenance(of: .BleedHydraulicBrakes)
		
		// Then
		XCTAssertEqual(last?.id, recentMaintenance.id)
	}
	
	func test_nextMaintenanceDate_returnsCorrectDate() {
		// Given
		let lastDate = Date()
		let maintenance = Maintenance(id: UUID(), maintenanceType: .BleedHydraulicBrakes, date: lastDate, reminder: true)
		maintenanceVM.maintenances = [maintenance]
		
		// When
		let nextDate = vm.calculateNextMaintenanceDate(for: .BleedHydraulicBrakes)
		
		// Then
		let expected = Calendar.current.date(byAdding: .day, value: MaintenanceType.BleedHydraulicBrakes.frequencyInDays, to: lastDate)
		XCTAssertEqual(nextDate, expected)
	}
	
	func test_daysUntilNextMaintenance_returnsCorrectDays() {
		// Given
		let lastDate = Date().addingTimeInterval(-5*24*3600) // 5 jours avant
		let maintenance = Maintenance(id: UUID(), maintenanceType: .BleedHydraulicBrakes, date: lastDate, reminder: true)
		maintenanceVM.maintenances = [maintenance]
		
		// When
		let days = vm.calculateDaysUntilNextMaintenance(type: .BleedHydraulicBrakes)
		
		// Then
		let expectedDate = Calendar.current.date(byAdding: .day, value: MaintenanceType.BleedHydraulicBrakes.frequencyInDays, to: lastDate)!
		let expectedDays = Calendar.current.dateComponents([.day], from: Date(), to: expectedDate).day
		XCTAssertEqual(days, expectedDays)
	}
	
	func test_fetchAllMaintenanceForOneType_returnsOnlyOneType() throws {
		// Given
		let brake = Maintenance(id: UUID(), maintenanceType: .BleedHydraulicBrakes, date: Date(), reminder: true)
		let runSoftwareAndBatteryDiagnostics = Maintenance(id: UUID(), maintenanceType: .RunSoftwareAndBatteryDiagnostics, date: Date(), reminder: true)
		store.maintenances = [brake.toLocal(), runSoftwareAndBatteryDiagnostics.toLocal()]
		
		// When
		let result = vm.fetchAllMaintenanceForOneType(type: .BleedHydraulicBrakes)
		
		// Then
		XCTAssertEqual(result.count, 1)
		XCTAssertEqual(result.first?.id, brake.id)
	}
	
	func test_fetchAllMaintenanceForOneType_handlesStoreError() {
		// Given
		store.shouldThrowStoreError = true
		
		// When
		let result = vm.fetchAllMaintenanceForOneType(type: .BleedHydraulicBrakes)
		
		// Then
		XCTAssertTrue(result.isEmpty)
		XCTAssertNotNil(vm.error)
		if case .dataUnavailable(let error) = vm.error {
			if case .modelNotFound = error {
				// succès
			} else {
				XCTFail("Expected StoreError.modelNotFound")
			}
		} else {
			XCTFail("Expected dataUnavailable error")
		}
		XCTAssertTrue(vm.showAlert)
	}
	
	func test_fetchAllMaintenanceForOneType_handlesLoadingError() {
		// Given
		store.shouldThrowLoadingError = true
		
		// When
		let result = vm.fetchAllMaintenanceForOneType(type: .BleedHydraulicBrakes)
		
		// Then
		XCTAssertTrue(result.isEmpty)
		XCTAssertNotNil(vm.error)
		if case .loadingDataFailed(let error) = vm.error {
			XCTAssertEqual(error, LoadingCocoaError.unknown)
		} else {
			XCTFail("Expected loadingDataFailed error")
		}
		XCTAssertTrue(vm.showAlert)
	}
	
}
