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
			MaintenanceView()
				.tabItem { Label("Entretiens", systemImage: "wrench") }
		}
	}
}
#Preview {
	ContentView()
}
