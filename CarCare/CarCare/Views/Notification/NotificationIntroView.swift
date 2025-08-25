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
	@EnvironmentObject var maintenanceVM: MaintenanceVM
	@EnvironmentObject var notificationVM: NotificationViewModel
	@AppStorage("hasSeenNotificationIntro") private var hasSeenNotificationIntro: Bool = false
	
    var body: some View {
		VStack(spacing: 20) {
			Text("Restez informé")
				.font(.title)
				.padding()
			
			Text("Activez les notifications pour être informé des rappels des entretiens à réaliser et ne rien manquer !")
				.multilineTextAlignment(.center)
				.padding()
			
			Button("Activer les notifications") {
				//NotificationManager.shared.requestAuthorization()
				
				/*UNUserNotificationCenter.current().getNotificationSettings { settings in // si l'utilisateur accpete les notifs alors elles sont créées
					if settings.authorizationStatus == .authorized {
						DispatchQueue.main.async {
							// Planifier toutes les notifications pour les maintenances avec reminder = true
							NotificationManager.shared.scheduleAllReminders(using: maintenanceVM)
						}
					}
				}*/
				notificationVM.requestAndScheduleNotifications()
				hasSeenNotificationIntro = true
			}
			.buttonStyle(.borderedProminent)
		}
		.padding()
		//Comme error est optionnel on crée un binding
		.alert("Erreur", isPresented: Binding(
			get: { notificationVM.error != nil },
			set: { _ in notificationVM.error = nil } //quand utilisateur ferme l'alerte : error = nil
		)) {
			Button("OK") { }
		} message: {
			Text(notificationVM.error?.localizedDescription ?? "")
		}
		.alert("Succès", isPresented: $notificationVM.showSuccessAlert) {
			Button("OK") { }
		} message: {
			Text("Notifications activées avec succès !")
		}
		// Mise à jour du ViewModel avec le vrai maintenanceVM une fois disponible
		.onAppear {
			notificationVM.maintenanceVM = maintenanceVM
		}
	}
}

#Preview {
    NotificationIntroView()
}
