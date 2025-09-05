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
	@Environment(\.scenePhase) private var scenePhase // quand utilisateur revient dans l'app
	@StateObject private var notificationVM: NotificationViewModel
	@StateObject private var bikeVM: BikeVM
	@StateObject private var maintenanceVM = MaintenanceVM()
	@StateObject private var appState: AppState
	@AppStorage("hasSeenNotificationIntro") private var hasSeenNotificationIntro: Bool = false
	@AppStorage("isDarkMode") private var isDarkMode: Bool = false
	
	init() {
		let appState = AppState(vehicleLoader: dependencyContainer.BikeLoader)
		_appState = StateObject(wrappedValue: appState)
		
		let maintenanceVM = MaintenanceVM()
		let notificationVM = NotificationViewModel(maintenanceVM: maintenanceVM)
		maintenanceVM.notificationVM = notificationVM
		_maintenanceVM = StateObject(wrappedValue: maintenanceVM)
		_notificationVM = StateObject(wrappedValue: notificationVM)
		
		let bikeVM = BikeVM(notificationVM: notificationVM) // injecte notificationVM
			_bikeVM = StateObject(wrappedValue: bikeVM)
	}
	
	var body: some Scene {
		WindowGroup {
			ZStack {
				switch appState.status {
				case .needsVehicleRegistration:
					Group {
						if hasSeenNotificationIntro {
							RegistrationView(bikeVM: bikeVM)
								.environmentObject(appState)
						} else {
							NotificationIntroView(maintenanceVM: maintenanceVM)
								.environmentObject(notificationVM)
						}
					}
					.transition(.asymmetric(
							   insertion: .move(edge: .trailing).combined(with: .opacity), 
							   removal: .move(edge: .leading).combined(with: .opacity)
						   ))
						   .zIndex(1)
				case .ready:
					ContentView(bikeVM: bikeVM, maintenanceVM: maintenanceVM)
						.environmentObject(appState)
						.transition(.asymmetric(
								   insertion: .move(edge: .trailing).combined(with: .opacity),
								   removal: .move(edge: .leading).combined(with: .opacity)
							   ))
							   .zIndex(0)
				}
			}
			.animation(.easeInOut(duration: 0.3), value: appState.status)
			.alert(isPresented: $appState.showAlert) {
					Alert(
						title: Text("Erreur"),
						message: Text(appState.error?.errorDescription ?? "Erreur inconnue"),
						dismissButton: .default(Text("OK")) {
							appState.showAlert = false
						}
					)
				}
		}
	}
}

