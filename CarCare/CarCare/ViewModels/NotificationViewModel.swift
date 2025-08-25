//
//  NotificationViewModel.swift
//  CarCare
//
//  Created by Ordinateur elena on 25/08/2025.
//

import Foundation
import UserNotifications

final class NotificationViewModel: ObservableObject {
	@Published var error: AppError?
	@Published var isLoading = false
	@Published var showSuccessAlert = false
	@Published var isAuthorized = false

	private let notificationManager: NotificationManagerProtocol
	var maintenanceVM: MaintenanceVM

	// Initialisation avec injection de dépendances (pour les tests)
	init(
		notificationManager: NotificationManagerProtocol = NotificationManager.shared,
		maintenanceVM: MaintenanceVM
	) {
		self.notificationManager = notificationManager
		self.maintenanceVM = maintenanceVM
	}

	// Méthode appelée par la vue
	func requestAndScheduleNotifications() {
		isLoading = true
		notificationManager.requestAuthorization { [weak self] result in
			guard let self = self else { return }

			DispatchQueue.main.async {
				self.isLoading = false

				switch result {
				case .success:
					self.checkAndScheduleNotifications()
				case .failure(let error):
					self.error = error
				}
			}
		}
	}

	// Vérifie les autorisations et planifie les notifications si nécessaire
	func checkAndScheduleNotifications() {
		UNUserNotificationCenter.current().getNotificationSettings { [weak self] settings in
			guard let self = self else { return }

			DispatchQueue.main.async {
				if settings.authorizationStatus == .authorized {
					self.notificationManager.scheduleAllReminders(using: self.maintenanceVM)
					self.showSuccessAlert = true
				} else {
					// Supprimer toutes les notifications planifiées
					self.notificationManager.cancelAllNotifications(using: self.maintenanceVM)
					self.showSuccessAlert = false
				}
			}
		}
	}
	
	//Maj un reminder
	func updateReminder(for maintenance: Maintenance, value: Bool) {
		if value {
			notificationManager.scheduleWeeklyNotifications(for: maintenance)
		} else {
			notificationManager.cancelWeeklyNotifications(for: maintenance)
		}
	}
}
