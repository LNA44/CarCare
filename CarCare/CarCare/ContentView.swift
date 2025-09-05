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
	
	var body: some View {
		TabView {
			NavigationStack {
				DashboardView(bikeVM: bikeVM, maintenanceVM: maintenanceVM)
			}
			.tabItem { Label("Accueil", systemImage: "house")}
			NavigationStack {
				MaintenanceView(bikeVM: bikeVM, maintenanceVM: maintenanceVM)
			}
			.tabItem { Label("Entretiens", systemImage: "wrench") }
			NavigationStack {
				SettingsView()
			}
			.tabItem { Label("Paramètres", systemImage: "gear") }
		}
	}
}

/*#Preview {
	ContentView()
}*/
