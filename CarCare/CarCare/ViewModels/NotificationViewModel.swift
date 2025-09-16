//
//  NotificationViewModel.swift
//  CarCare
//
//  Created by Ordinateur elena on 25/08/2025.
//

import Foundation
import UserNotifications
import Combine

final class NotificationViewModel: ObservableObject {
	@Published var error: AppError?
	@Published var isAuthorized = false
	var maintenanceVM: MaintenanceVM

	// Initialisation avec injection de dépendances (pour les tests)
	init(maintenanceVM: MaintenanceVM) {
		self.maintenanceVM = maintenanceVM
	}
	
	// Demande d'autorisation et planification des notifications
	func requestAndScheduleNotifications() {
			UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { [weak self] granted, _ in
				DispatchQueue.main.async {
					self?.isAuthorized = granted
				}
			}
		}
	
	// Planifie les notifications pour un type de maintenance
	func scheduleNotifications(for type: MaintenanceType, until endDate: Date) {
		guard isAuthorized else { return }

		   // Calcul du nombre de jours restants
		   let daysRemaining = Calendar.current.dateComponents([.day], from: Date(), to: endDate).day ?? 0
		   // Si plus de 30 jours, ne rien planifier
		   guard daysRemaining <= 30 else { return }
		   // Annule les notifications existantes pour ce type avant d’en recréer
		   cancelNotifications(for: type)
		   // Planifie une notification chaque semaine jusqu'à endDate
		   var nextDate = Date()
		   while nextDate <= endDate {
			   scheduleNotification(for: type, on: nextDate)
			   nextDate = Calendar.current.date(byAdding: .weekOfYear, value: 1, to: nextDate)!
		   }
	}
	
	private func scheduleNotification(for type: MaintenanceType, on date: Date) {
			let content = UNMutableNotificationContent()
			content.title = "Entretien à venir"
			content.body = "Votre entretien \(type.localizedName) est prévu le \(date.formatted(date: .numeric, time: .omitted))"
			content.sound = .default
			
			let trigger = UNCalendarNotificationTrigger(
				dateMatching: Calendar.current.dateComponents([.year, .month, .day, .hour, .minute], from: date),
				repeats: false
			)
			
			let request = UNNotificationRequest(
				identifier: type.id,
				content: content,
				trigger: trigger
			)
			
			UNUserNotificationCenter.current().add(request) { error in
				if let error = error {
					print("Erreur planification notif: \(error)")
				} else {
					print("Notification planifiée pour \(type.localizedName) le \(date)")
				}
			}
		}
	
	func cancelNotifications(for type: MaintenanceType) {
			UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [type.id])
	}
		
	func cancelAllNotifications() {
			UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
	}
	
	func updateReminder(for maintenanceID: UUID, value: Bool) {
		// Récupère la maintenance correspondant à l'ID
		guard let maintenance = maintenanceVM.maintenances.first(where: { $0.id == maintenanceID }) else { return }
		let type = maintenance.maintenanceType
		
		if value {
			// Vérifie la prochaine maintenance pour ce type
			guard let nextDate = maintenanceVM.nextMaintenanceDate(for: type) else { return }
			
			// Si la prochaine maintenance est dans moins de 30 jours et que l'utilisateur a autorisé les notifications
			if nextDate <= Date().addingTimeInterval(30*24*3600), isAuthorized {
				self.scheduleNotifications(for: type, until: nextDate)
			}
		} else {
			// Annule toutes les notifications pour ce type
			self.cancelNotifications(for: type)
		}
	}
}
