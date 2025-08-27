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
	@StateObject private var themeVM = ThemeViewModel()
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
					if hasSeenNotificationIntro {
						RegistrationView()
							.environmentObject(appState)
							.environmentObject(bikeVM)
					} else {
						NotificationIntroView()
							.environmentObject(maintenanceVM)
							.environmentObject(notificationVM) //obligatoire car sinon on ne peut pas instancier NitifcationVM dans l'init de NotificationIntroView car maintenanceVM est un environment
					}
				case .ready:
					ContentView()
						.environmentObject(bikeVM)
						.environmentObject(maintenanceVM)
						.environmentObject(themeVM)
				}
			}
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
		.onChange(of: scenePhase) { newPhase in
			if newPhase == .active {
				themeVM.applyInterfaceStyle()
			}
		}
	}
}

