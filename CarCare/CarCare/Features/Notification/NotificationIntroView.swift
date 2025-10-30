//
//  NotificationIntroView.swift
//  CarCare
//
//  Created by Ordinateur elena on 25/08/2025.
//

import SwiftUI
import UserNotifications
//apparait à la première ouverture de l'app
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
			
			Text(NSLocalizedString("enable_notifications_text_key", comment: ""))
				.multilineTextAlignment(.center)
				.padding()
			
			Button(NSLocalizedString("enable_notifications_button_key", comment: "")) {
				Task {
                    haptic.impactOccurred()
					await notificationVM.requestAndScheduleNotifications() // Demande l'autorisation et planifie si accepté
					hasSeenNotificationIntro = true
				}
			}
			.buttonStyle(.borderedProminent)
		}
		.padding()
		//Comme error est optionnel on crée un binding
		.alert(NSLocalizedString("error_title_key", comment: "Titre de l'alerte d'erreur"), isPresented: Binding(
			get: { notificationVM.error != nil },
			set: { _ in notificationVM.error = nil } //quand utilisateur ferme l'alerte : error = nil
		)) {
			Button("OK") { }
		} message: {
			Text(notificationVM.error?.localizedDescription ?? "")
		}

		// Mise à jour du ViewModel avec le vrai maintenanceVM une fois disponible
		.onAppear {
			notificationVM.maintenanceVM = maintenanceVM
		}
	}
}

