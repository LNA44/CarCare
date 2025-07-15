//
//  MileageRecordStore.swift
//  CarCare
//
//  Created by Ordinateur elena on 15/07/2025.
//

import Foundation

protocol MileageRecordStore {
	func insert(_ mileage: LocalMileageRecord) throws
	func retrieve() throws -> [LocalMileageRecord]
}
