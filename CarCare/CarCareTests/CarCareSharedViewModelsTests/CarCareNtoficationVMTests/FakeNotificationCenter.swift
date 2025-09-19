//
//  MockNotificationCenter.swift
//  CarCareTests
//
//  Created by Ordinateur elena on 19/09/2025.
//

import XCTest
@testable import CarCare

final class FakeNotificationCenter: NotificationCenterProtocol {
	var addedRequests: [UNNotificationRequest] = []
	var removedIdentifiers: [String] = []
	var removeAllCalled = false
	var requestAuthorizationCalled = false
	var granted: Bool = true
	
	func add(_ request: UNNotificationRequest, withCompletionHandler completionHandler: (@Sendable (Error?) -> Void)?) {
		addedRequests.append(request)
		completionHandler?(nil)
	}
	
	func removePendingNotificationRequests(withIdentifiers identifiers: [String]) {
		removedIdentifiers.append(contentsOf: identifiers)
	}
	
	func removeAllPendingNotificationRequests() {
		removeAllCalled = true
	}
	
	func requestAuthorization(options: UNAuthorizationOptions) async throws -> Bool {
		requestAuthorizationCalled = true
		return granted
	}
}
