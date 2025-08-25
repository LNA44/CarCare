//
//  ParametersView.swift
//  CarCare
//
//  Created by Ordinateur elena on 25/08/2025.
//

import SwiftUI

struct SettingsView: View {
	@AppStorage("isDarkMode") private var isDarkMode: Bool = false
	
	var body: some View {
		NavigationView {
			Form {
				Section(header: Text("Apparence")) {
					Toggle(isOn: $isDarkMode) {
						Text("Mode sombre")
					}
					.onChange(of: isDarkMode) { value in
						// Met à jour l'interface
						ThemeManager.shared.applyInterfaceStyle(value)
					}
				}
				
				Section(header: Text("Notifications")) {
					Button(action: {
						// Ouvre les paramètres iOS
						if let url = URL(string: UIApplication.openSettingsURLString) {
							UIApplication.shared.open(url)
						}
					}) {
						Text("Gérer les notifications")
					}
				}
				
				Section(header: Text("Informations")) {
					NavigationLink("Mentions légales") {
						LegalView()
					}
				}
			}
			.navigationTitle("Paramètres")
			.onAppear {
				ThemeManager.shared.applyInterfaceStyle(isDarkMode) // applique le style au chargement
			}
		}
	}
}

#Preview {
    SettingsView()
}
