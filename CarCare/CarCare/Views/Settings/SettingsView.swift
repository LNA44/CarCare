//
//  ParametersView.swift
//  CarCare
//
//  Created by Ordinateur elena on 25/08/2025.
//

import SwiftUI

struct SettingsView: View {
	@EnvironmentObject var themeVM: ThemeViewModel
	
	var body: some View {
		Form {
			Section(header: Text("Apparence")) {
				Toggle(isOn: $themeVM.isDarkMode) {
					Text("Mode sombre")
				}
				.onChange(of: themeVM.isDarkMode) {_, value in
					// Met à jour l'interface
					themeVM.applyInterfaceStyle()
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
			themeVM.applyInterfaceStyle() // applique le style au chargement
		}
	}
}

#Preview {
    SettingsView()
}
