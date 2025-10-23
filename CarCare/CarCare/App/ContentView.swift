//
//  ContentView.swift
//  CarCare
//
//  Created by Ordinateur elena on 15/07/2025.
//

import SwiftUI

struct ContentView: View {
	@ObservedObject var bikeVM: BikeVM
	@ObservedObject var maintenanceVM: MaintenanceVM
	@ObservedObject var notificationVM: NotificationViewModel
	
	var body: some View {
		TabView {
			NavigationStack {
				DashboardView(bikeVM: bikeVM, maintenanceVM: maintenanceVM, notificationVM: notificationVM)
			}
			.tabItem { Label("Accueil", systemImage: "house")}
			NavigationStack {
				MaintenanceView(bikeVM: bikeVM, maintenanceVM: maintenanceVM, notificationVM: notificationVM)
			}
			.tabItem { Label("Entretiens", systemImage: "wrench") }
			NavigationStack {
				SettingsView()
			}
			.tabItem { Label("Paramètres", systemImage: "gear") }
		}
		.tint(Color("TextColor"))
	}
}
