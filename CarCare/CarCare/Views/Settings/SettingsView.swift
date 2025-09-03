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
			Section(header: Text("Apparence")
				.foregroundColor(Color("TextColor"))
				.font(.system(size: 16, weight: .bold, design: .rounded))
			) {
				Toggle(isOn: $themeVM.isDarkMode) {
					Text("Mode sombre")
						.foregroundColor(Color("TextColor"))
						.font(.system(size: 16, weight: .regular, design: .rounded))
				}
				.tint(Color("DoneColor"))
				.onChange(of: themeVM.isDarkMode) {_, value in
					// Met à jour l'interface
					themeVM.applyInterfaceStyle()
				}
			}
			
			Section(header: Text("Notifications")
				.foregroundColor(Color("TextColor"))
				.font(.system(size: 16, weight: .bold, design: .rounded))
			) {
				Button(action: {
					// Ouvre les paramètres iOS
					if let url = URL(string: UIApplication.openSettingsURLString) {
						UIApplication.shared.open(url)
					}
				}) {
					Text("Gérer les notifications")
						.foregroundColor(Color("TextColor"))
						.font(.system(size: 16, weight: .regular, design: .rounded))
				}
			}
			
			Section(header: Text("Informations")
				.foregroundColor(Color("TextColor"))
				.font(.system(size: 16, weight: .bold, design: .rounded))
			) {
				NavigationLink(destination: LegalView()) {
					Text("Mentions légales")
						.foregroundColor(Color("TextColor"))
						.font(.system(size: 16, weight: .regular, design: .rounded))
				}
			}
		}
		.background(Color("BackgroundColor"))
		.toolbar {
			ToolbarItem(placement: .principal) {
				Text("Paramètres")
					.font(.system(size: 22, weight: .bold, design: .rounded))
					.foregroundColor(Color("TextColor"))
			}
		}
		.onAppear {
			themeVM.applyInterfaceStyle() // applique le style au chargement
		}
	}
}

#Preview {
    SettingsView()
}
