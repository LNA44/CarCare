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
	@StateObject private var bikeVM = BikeVM()
	@StateObject private var maintenanceVM = MaintenanceVM()
	@StateObject private var notificationVM: NotificationViewModel
	@StateObject private var appState: AppState
	@AppStorage("hasSeenNotificationIntro") private var hasSeenNotificationIntro: Bool = false
	@AppStorage("isDarkMode") private var isDarkMode: Bool = false
	
	init() {
		let appState = AppState(vehicleLoader: dependencyContainer.BikeLoader)
		_appState = StateObject(wrappedValue: appState)
		let maintenanceVM = MaintenanceVM()
		
		
		let notificationVM = NotificationViewModel(maintenanceVM: maintenanceVM)
		// NotificationViewModel dépend de maintenanceVM
		//_notificationVM = StateObject(wrappedValue: NotificationViewModel(maintenanceVM: maintenanceVM))
		
		// Passe notificationVM à maintenanceVM via l'init (ou setter)
		maintenanceVM.notificationVM = notificationVM
		
		// Injection de notificationVM dans maintenanceVM
		//_maintenanceVM.wrappedValue.setNotificationVM(_notificationVM.wrappedValue)
		_maintenanceVM = StateObject(wrappedValue: maintenanceVM)
		_notificationVM = StateObject(wrappedValue: notificationVM)
	}
	
    var body: some Scene {
        WindowGroup {
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
			}
		}
		.onChange(of: scenePhase) { newPhase in
			if newPhase == .active {
				ThemeManager.shared.applyInterfaceStyle(isDarkMode)
				if bikeVM.bike != nil {
					notificationVM.checkAndScheduleNotifications()
				}
				print("Aucun vélo enregistré → pas de notification")
				return
			}
		}
	}
}

