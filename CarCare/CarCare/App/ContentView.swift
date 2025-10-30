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
    @State private var selectedTab = 0
    
    var body: some View {
        ZStack(alignment: .bottom) {
            GeometryReader { geometry in
                HStack(spacing: 0) { //contient les trois écrans, dont deux sont en dehors de l'écran de l'iphone
                    // Onglet 0
                    NavigationStack {
                        DashboardView(bikeVM: bikeVM, maintenanceVM: maintenanceVM, notificationVM: notificationVM)
                    }
                    .frame(width: geometry.size.width)
                    
                    // Onglet 1
                    NavigationStack {
                        MaintenanceView(bikeVM: bikeVM, maintenanceVM: maintenanceVM, notificationVM: notificationVM)
                    }
                    .frame(width: geometry.size.width)
                    
                    // Onglet 2
                    NavigationStack {
                        SettingsView()
                    }
                    .frame(width: geometry.size.width)
                }
                .offset(x: -CGFloat(selectedTab) * geometry.size.width) //on décale le HStack pour montrer un autre écran
                .animation(.easeInOut(duration: 0.3), value: selectedTab)
            }
            
            // Tab Bar
            HStack(spacing: 0) {
                TabButton(icon: "house", title: "Accueil", isSelected: selectedTab == 0) {
                    selectedTab = 0
                }
                
                TabButton(icon: "wrench", title: "Entretiens", isSelected: selectedTab == 1) {
                    selectedTab = 1
                }
                
                TabButton(icon: "gearshape", title: "Paramètres", isSelected: selectedTab == 2) {
                    selectedTab = 2
                }
            }
            .padding(.horizontal)
            .padding(.top, 8)
            .padding(.bottom, 20)
            .background(
                Color.white.opacity(0.8)
                    .shadow(color: .black.opacity(0.1), radius: 10, y: -5)
            )
            .zIndex(1)
        }
        .ignoresSafeArea(edges: .bottom)
        .tint(Color("TextColor"))
    }
}

struct TabButton: View {
    let icon: String
    let title: String
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 4) {
                Image(systemName: isSelected ? "\(icon).fill" : icon)
                    .font(.system(size: 24))
                    .foregroundColor(isSelected ? Color("TextColor") : Color.gray)
                
                Text(title)
                    .font(.caption2)
                    .foregroundColor(isSelected ? Color("TextColor") : Color.gray)
            }
            .frame(maxWidth: .infinity)
        }
    }
}
