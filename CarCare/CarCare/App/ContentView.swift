//
//  ContentView.swift
//  CarCare
//
//  Created by Ordinateur elena on 15/07/2025.
//

import SwiftUI

struct ContentView: View {
    @AppStorage("isDarkMode") private var isDarkMode = false
    @ObservedObject var bikeVM: BikeVM
    @ObservedObject var maintenanceVM: MaintenanceVM
    @ObservedObject var notificationVM: NotificationViewModel
    @State private var dashboardViewID = UUID()
    @State private var maintenanceViewID = UUID()
    @State private var settingsViewID = UUID()
    @State private var selectedTab = 0
    let haptic = UIImpactFeedbackGenerator(style: .light)
    
    var body: some View {
        ZStack(alignment: .bottom) {
            GeometryReader { geometry in
                HStack(spacing: 0) { //contient les trois écrans, dont deux sont en dehors de l'écran de l'iphone
                    // Onglet 0
                    NavigationStack {
                        DashboardView(bikeVM: bikeVM, maintenanceVM: maintenanceVM, notificationVM: notificationVM)
                            
                    }
                    .id(dashboardViewID)
                    .frame(width: geometry.size.width)
                    
                    // Onglet 1
                    NavigationStack {
                        MaintenanceView(bikeVM: bikeVM, maintenanceVM: maintenanceVM, notificationVM: notificationVM)
                    }
                    .id(maintenanceViewID)
                    .frame(width: geometry.size.width)
                    
                    // Onglet 2
                    NavigationStack {
                        SettingsView()
                    }
                    .id(settingsViewID)
                    .frame(width: geometry.size.width)
                }
                .offset(x: -CGFloat(selectedTab) * geometry.size.width) //on décale le HStack pour montrer un autre écran
                .animation(.easeInOut(duration: 0.3), value: selectedTab)
            }
            
            // Tab Bar
            HStack(spacing: 0) {
                TabButton(icon: "house", title: "Accueil", isSelected: selectedTab == 0) {
                    if selectedTab == 0 {
                        // On crée un décalage temporaire pour déclencher l'animation
                        withAnimation(.easeInOut(duration: 0.3)) {
                            selectedTab = -1 // valeur temporaire hors écran
                        }
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                            dashboardViewID = UUID() // revient à la racine
                            selectedTab = 0 // revient sur l'onglet
                        }
                    } else {
                        withAnimation(.easeInOut(duration: 0.3)) {
                            selectedTab = 0
                        }
                    }
                }
                
                TabButton(icon: "wrench", title: "Entretiens", isSelected: selectedTab == 1) {
                    if selectedTab == 1 {
                        // Forcer la reconstruction de la vue => revient à la racine
                        maintenanceViewID = UUID()
                    } else {
                        selectedTab = 1
                    }
                }
                
                TabButton(icon: "gearshape", title: "Paramètres", isSelected: selectedTab == 2) {
                    if selectedTab == 2 {
                        // Forcer la reconstruction de la vue => revient à la racine
                        settingsViewID = UUID()
                    } else {
                        selectedTab = 2
                    }
                }
            }
            .padding(.horizontal)
            .padding(.top, 8)
            .padding(.bottom, 20)
            .background(
                Color("TabColor").opacity(0.9)
                    .shadow(color: .black.opacity(0.1), radius: 10, y: -5)
            )
            .zIndex(1)
        }
        .onChange(of: selectedTab) { oldValue, newValue in
            haptic.impactOccurred()
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
