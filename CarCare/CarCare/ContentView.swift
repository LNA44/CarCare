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
			DashboardView()
				.environmentObject(bikeVM)
				.environmentObject(maintenanceVM)
				.tabItem { Label("Accueil", systemImage: "house")}
			MaintenanceView()
				.environmentObject(maintenanceVM)
				.tabItem { Label("Entretiens", systemImage: "wrench") }
			SettingsView()
				.environmentObject(themeVM)
				.tabItem { Label("Paramètres", systemImage: "gear") }
		}
	}
}
#Preview {
	ContentView()
}
