//
//  ContentView.swift
//  CarCare
//
//  Created by Ordinateur elena on 15/07/2025.
//

import SwiftUI

struct ContentView: View {
	@StateObject private var bikeVM = BikeVM()
	@StateObject private var maintenanceVM = MaintenanceVM()
	
	var body: some View {
		TabView {
			DashboardView()
				.environmentObject(bikeVM)
				.environmentObject(maintenanceVM)
				.tabItem { Label("Accueil", systemImage: "house")}
			MaintenanceView()
				.environmentObject(maintenanceVM)
				.tabItem { Label("Entretiens", systemImage: "wrench") }
		}
	}
}
#Preview {
	ContentView()
}
