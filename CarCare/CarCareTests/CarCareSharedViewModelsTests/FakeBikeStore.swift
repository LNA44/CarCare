//
//  FakeBikeVM.swift
//  CarCareTests
//
//  Created by Ordinateur elena on 18/09/2025.
//

import XCTest
@testable import CarCare

final class FakeBikeStore: BikeStore {
	private var storedBike: LocalBike?
	
	func insert(_ bike: LocalBike) throws {
		storedBike = bike
	}
	
	func retrieve() throws -> LocalBike? {
		storedBike
	}
	
	func update(_ bike: LocalBike) throws {
		storedBike = bike
	}
	
	func delete(_ bike: LocalBike) throws {
		storedBike = nil
	}
}

