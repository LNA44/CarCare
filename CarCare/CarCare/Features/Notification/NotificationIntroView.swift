//
//  NotificationIntroView.swift
//  CarCare
//
//  Created by Ordinateur elena on 25/08/2025.
//

import SwiftUI
import UserNotifications

struct NotificationIntroView: View {
	@ObservedObject var maintenanceVM: MaintenanceVM
	@ObservedObject var notificationVM: NotificationViewModel
	@AppStorage("hasSeenNotificationIntro") private var hasSeenNotificationIntro: Bool = false
    let haptic = UIImpactFeedbackGenerator(style: .medium)
	
    var body: some View {
		VStack(spacing: 20) {
			Text(NSLocalizedString("stay_informed_key", comment: ""))
				.font(.title)
				.padding()
                .accessibilityAddTraits(.isHeader)
                .accessibilityLabel(NSLocalizedString("stay_informed_key", comment: "Stay informed title"))
            
			Text(NSLocalizedString("enable_notifications_text_key", comment: ""))
				.multilineTextAlignment(.center)
				.padding()
                .accessibilityLabel(NSLocalizedString("enable_notifications_text_key", comment: "Explanation about enabling notifications"))
                .accessibilityHint("Explains why enabling notifications keeps you updated")
			
			Button(NSLocalizedString("enable_notifications_button_key", comment: "")) {
				Task {
                    haptic.impactOccurred()
					await notificationVM.requestAndScheduleNotifications() // Demande l'autorisation et planifie si accepté
					hasSeenNotificationIntro = true
				}
			}
			.buttonStyle(.borderedProminent)
            .accessibilityLabel(NSLocalizedString("enable_notifications_button_key", comment: "Enable notifications button"))
            .accessibilityHint("Double tap to allow notifications and stay updated")
            .accessibilityAddTraits(.isButton)
        }
		.padding()
		.alert(NSLocalizedString("error_title_key", comment: "Error title"), isPresented: Binding(
			get: { notificationVM.error != nil },
			set: { _ in notificationVM.error = nil }
		)) {
            Button("OK") { }
                .accessibilityLabel("OK")
                .accessibilityHint("Dismiss the error message")
        } message: {
            Text(notificationVM.error?.localizedDescription ?? "")
                .accessibilityLabel(notificationVM.error?.localizedDescription ?? "An unknown error occurred")
        }

		.onAppear {
			notificationVM.maintenanceVM = maintenanceVM
		}
	}
}

