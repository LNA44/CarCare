//
//  ParametersView.swift
//  CarCare
//
//  Created by Ordinateur elena on 25/08/2025.
//

import SwiftUI

struct SettingsView: View {
	@AppStorage("isDarkMode") private var isDarkMode: Bool = false
	@Environment(\.colorScheme) private var colorScheme
    let haptic = UIImpactFeedbackGenerator(style: .medium)

	var body: some View {
		Form {
			Section(header: Text(NSLocalizedString("appearence_key", comment: ""))
				.foregroundColor(Color("TextColor"))
				.font(.system(size: 16, weight: .bold, design: .default))
			) {
				Toggle(isOn: $isDarkMode) {
					Text(NSLocalizedString("dark_mode_key", comment: ""))
						.foregroundColor(Color("TextColor"))
						.font(.system(size: 16, weight: .regular, design: .default))
				}
				.tint(Color("DoneColor"))
				.onChange(of: isDarkMode) {_, value in
						applyInterfaceStyle(value)
				}
                .listRowBackground(Color("MaintenanceHistoryColor"))
                .accessibilityLabel(Text("Dark Mode"))
                .accessibilityHint(Text("Double tap to enable or disable dark mode"))
                .accessibilityValue(Text(isDarkMode ? "Enabled" : "Disabled"))
            }
			
			Section(header: Text(NSLocalizedString("notifications_key", comment: ""))
				.foregroundColor(Color("TextColor"))
				.font(.system(size: 16, weight: .bold, design: .default))
			) {
				Button(action: {
					// Ouvre les paramètres iOS
					if let url = URL(string: UIApplication.openSettingsURLString) {
						UIApplication.shared.open(url)
					}
				}) {
					Text(NSLocalizedString("handle_notifications_key", comment: ""))
						.foregroundColor(Color("TextColor"))
						.font(.system(size: 16, weight: .regular, design: .default))
				}
				.listRowBackground(Color("MaintenanceHistoryColor"))
                .accessibilityLabel(Text("Manage Notifications"))
                .accessibilityHint(Text("Double tap to open iPhone settings and manage notification preferences"))
			}
			
			Section(header: Text(NSLocalizedString("information_key", comment: ""))
				.foregroundColor(Color("TextColor"))
				.font(.system(size: 16, weight: .bold, design: .default))
			) {
				NavigationLink(destination: LegalView()) {
					Text(NSLocalizedString("legal_notice_key", comment: ""))
						.foregroundColor(Color("TextColor"))
						.font(.system(size: 16, weight: .regular, design: .default))
				}
                .simultaneousGesture(
                    TapGesture().onEnded {
                        haptic.impactOccurred()
                    }
                )
                .accessibilityLabel(Text("Legal Notice"))
                .accessibilityHint(Text("Double tap to view the app’s legal information"))
            }
			.listRowBackground(Color("MaintenanceHistoryColor"))

		}
		.onAppear {
			// Au démarrage, synchroniser le toggle avec le système
			isDarkMode = colorScheme == .dark
		}
		.onChange(of: colorScheme) {_, newScheme in
			// Quand le téléphone change de mode, mettre à jour le toggle
			isDarkMode = newScheme == .dark
		}
		.scrollContentBackground(.hidden) 
		.background(Color("BackgroundColor"))
		.toolbar {
			ToolbarItem(placement: .principal) {
				Text(NSLocalizedString("navigation_title_settings_key", comment: ""))
					.font(.system(size: 22, weight: .bold, design: .default))
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
