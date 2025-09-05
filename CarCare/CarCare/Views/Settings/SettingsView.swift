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
		Form {
			Section(header: Text(NSLocalizedString("appearence_key", comment: ""))
				.foregroundColor(Color("TextColor"))
				.font(.system(size: 16, weight: .bold, design: .rounded))
			) {
				Toggle(isOn: $isDarkMode) {
					Text(NSLocalizedString("dark_mode_key", comment: ""))						.foregroundColor(Color("TextColor"))
						.font(.system(size: 16, weight: .regular, design: .rounded))
				}
				.tint(Color("DoneColor"))
				.onChange(of: isDarkMode) {_, value in
						applyInterfaceStyle(value)
				}
			}
			
			Section(header: Text(NSLocalizedString("notifications_key", comment: ""))
				.foregroundColor(Color("TextColor"))
				.font(.system(size: 16, weight: .bold, design: .rounded))
			) {
				Button(action: {
					// Ouvre les paramètres iOS
					if let url = URL(string: UIApplication.openSettingsURLString) {
						UIApplication.shared.open(url)
					}
				}) {
					Text(NSLocalizedString("handle_notifications_key", comment: ""))
						.foregroundColor(Color("TextColor"))
						.font(.system(size: 16, weight: .regular, design: .rounded))
				}
			}
			
			Section(header: Text(NSLocalizedString("information_key", comment: ""))
				.foregroundColor(Color("TextColor"))
				.font(.system(size: 16, weight: .bold, design: .rounded))
			) {
				NavigationLink(destination: LegalView()) {
					Text(NSLocalizedString("legal_notice_key", comment: ""))
						.foregroundColor(Color("TextColor"))
						.font(.system(size: 16, weight: .regular, design: .rounded))
				}
			}
		}
		.background(Color("BackgroundColor"))
		.toolbar {
			ToolbarItem(placement: .principal) {
				Text(NSLocalizedString("navigation_title_settings_key", comment: ""))
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
