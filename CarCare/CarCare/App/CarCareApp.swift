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
	@StateObject private var maintenanceVM: MaintenanceVM
	@StateObject private var appState: AppState
	@StateObject private var subscriptionManager = SubscriptionManager.shared
    
	@AppStorage("hasSeenNotificationIntro") private var hasSeenNotificationIntro: Bool = false
	@AppStorage("isDarkMode") private var isDarkMode: Bool = false
	@AppStorage("hasSeenOnboarding") var hasSeenOnboarding: Bool = false
	
	init() {
		let appState = AppState(vehicleLoader: dependencyContainer.BikeLoader)
		_appState = StateObject(wrappedValue: appState)
		
		let maintenanceVM = MaintenanceVM()
		_maintenanceVM = StateObject(wrappedValue: maintenanceVM)
		
		let notificationVM = NotificationViewModel(maintenanceVM: maintenanceVM)
		maintenanceVM.notificationVM = notificationVM
		_notificationVM = StateObject(wrappedValue: notificationVM)
		
		let bikeVM = BikeVM(notificationVM: notificationVM) // injecte notificationVM
			_bikeVM = StateObject(wrappedValue: bikeVM)
		
#if DEBUG
let defaults = UserDefaults.standard
defaults.set(false, forKey: "isPremiumUser")
#endif
	}
	
	var body: some Scene {
		WindowGroup {
			ZStack {
				switch appState.status {
				case .needsVehicleRegistration:
					Group {
						if hasSeenOnboarding {
							if hasSeenNotificationIntro {
								RegistrationView(bikeVM: bikeVM)
									.environmentObject(appState)
									.environmentObject(subscriptionManager)
							} else {
								NotificationIntroView(maintenanceVM: maintenanceVM, notificationVM: notificationVM)
									.environmentObject(subscriptionManager)
							}
						} else {
							OnboardingView()
						}
					}
					.transition(.asymmetric(
							   insertion: .move(edge: .trailing).combined(with: .opacity), 
							   removal: .move(edge: .leading).combined(with: .opacity)
						   ))
						   .zIndex(1)
				case .ready:
					ContentView(bikeVM: bikeVM, maintenanceVM: maintenanceVM, notificationVM: notificationVM)
						.environmentObject(appState)
						.environmentObject(subscriptionManager)
						.transition(.asymmetric(
								   insertion: .move(edge: .trailing).combined(with: .opacity),
								   removal: .move(edge: .leading).combined(with: .opacity)
							   ))
							   .zIndex(0)
				}
			}
			.onChange(of: scenePhase) {_, newPhase in
				if newPhase == .active {
					Task {
						await subscriptionManager.checkCurrentEntitlements()
					}
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

