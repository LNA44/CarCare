//
//  ContentView.swift
//  CarCare
//
//  Created by Ordinateur elena on 15/07/2025.
//

import SwiftUI

struct ContentView: View {
	var body: some View {
		TabView {
			DashboardView()
				.tabItem { Label("Accueil", systemImage: "house")}
			Maintenance_FollowUpView()
				.tabItem { Label("Profil", systemImage: "wrench") }
			Fuel_FollowUpView()
				.tabItem { Label("Réglages", systemImage: "fuelpump") }
			Mileage_FollowUpView()
				.tabItem { Label("Réglages", systemImage: "speedometer") }
			Vehicle_ProfileView()
				.tabItem { Label("Réglages", systemImage: "car") }
		}
	}
}
#Preview {
	ContentView()
}
