//
//  ParametersView.swift
//  CarCare
//
//  Created by Ordinateur elena on 25/08/2025.
//

import SwiftUI

struct SettingsView: View {
	//@EnvironmentObject var themeVM: ThemeViewModel
	@AppStorage("isDarkMode") private var isDarkMode: Bool = false

	var body: some View {
		Form {
			Section(header: Text("Apparence")
				.foregroundColor(Color("TextColor"))
				.font(.system(size: 16, weight: .bold, design: .rounded))
			) {
				Toggle(isOn: $isDarkMode) {
					Text("Mode sombre")
						.foregroundColor(Color("TextColor"))
						.font(.system(size: 16, weight: .regular, design: .rounded))
				}
				.tint(Color("DoneColor"))
				.onChange(of: isDarkMode) { value in
								applyInterfaceStyle(value)
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
	}
}

extension SettingsView {
	private func applyInterfaceStyle(_ darkMode: Bool) {
		guard let window = UIApplication.shared.connectedScenes
			.compactMap({ $0 as? UIWindowScene })
			.first?.windows.first else { return }
		
		window.overrideUserInterfaceStyle = darkMode ? .dark : .light
	}
}

#Preview {
	SettingsView()
}
