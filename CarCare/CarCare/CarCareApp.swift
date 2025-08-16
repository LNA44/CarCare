//
//  CarCareApp.swift
//  CarCare
//
//  Created by Ordinateur elena on 15/07/2025.
//

import SwiftUI

@main
struct CarCareApp: App {
	let dependencyContainer = DependencyContainer.shared
	
	@StateObject private var appState: AppState
	
	init() {
		let appState = AppState(vehicleLoader: dependencyContainer.BikeLoader)
		_appState = StateObject(wrappedValue: appState)
	}
	
    var body: some Scene {
        WindowGroup {
			switch appState.status {
			case .loading:
				LoadingView()
			case .needsVehicleRegistration:
				RegistrationView()
					.environmentObject(appState)
			case .ready:
				ContentView()
			}
        }
    }
}
