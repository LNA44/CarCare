//
//  ContentView.swift
//  CarCare
//
//  Created by Ordinateur elena on 15/07/2025.
//

import SwiftUI

struct ContentView: View {
	@EnvironmentObject var bikeVM: BikeVM
	@EnvironmentObject var maintenanceVM: MaintenanceVM
	@EnvironmentObject var themeVM: ThemeViewModel
	
	var body: some View {
		TabView {
			NavigationStack {
				DashboardView()
			}
			.tabItem { Label("Accueil", systemImage: "house")}
			.environmentObject(bikeVM)
			.environmentObject(maintenanceVM)
			NavigationStack {
				MaintenanceView()
			}
			.tabItem { Label("Entretiens", systemImage: "wrench") }
			.environmentObject(maintenanceVM)
			NavigationStack {
				SettingsView()
			}
			.tabItem { Label("Paramètres", systemImage: "gear") }
		}
	}
}

#Preview {
	ContentView()
}
