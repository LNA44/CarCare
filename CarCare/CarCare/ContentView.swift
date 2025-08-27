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
		NavigationStack {
			TabView {
				DashboardView()
					.tabItem { Label("Accueil", systemImage: "house")}
				MaintenanceView()
					.tabItem { Label("Entretiens", systemImage: "wrench") }
				SettingsView()
					.tabItem { Label("Paramètres", systemImage: "gear") }
			}
		}
		.environmentObject(bikeVM)
		.environmentObject(maintenanceVM)
	}
}

#Preview {
	ContentView()
}
