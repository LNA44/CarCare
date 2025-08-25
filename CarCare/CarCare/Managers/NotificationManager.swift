//
//  NotificationManager.swift
//  CarCare
//
//  Created by Ordinateur elena on 25/08/2025.
//

import Foundation
import UserNotifications
//notifications locales

protocol NotificationManagerProtocol {
	func requestAuthorization(completion: @escaping (Result<Void, AppError>) -> Void)
	func scheduleAllReminders(using maintenanceVM: MaintenanceVM)
	func cancelAllNotifications(using maintenanceVM: MaintenanceVM)
	func scheduleWeeklyNotifications(for maintenance: Maintenance)
	func cancelWeeklyNotifications(for maintenance: Maintenance)
}

class NotificationManager: NotificationManagerProtocol {
	static let shared = NotificationManager()
	@Published var isAuthorized: Bool = false
	
	private init() {}
	
	/*func requestAuthorization() {
		UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
			DispatchQueue.main.async {
				self.isAuthorized = granted
			}
		}
	}*/
	
	func requestAuthorization(completion: @escaping (Result<Void, AppError>) -> Void) {
		UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
			if let error = error {
				completion(.failure(.notificationError(error)))
				return
			}
			completion(granted ? .success(()) : .failure(.notificationNotAuthorized))
		}
	}
	
	/*func checkAuthorizationStatus() {
		UNUserNotificationCenter.current().getNotificationSettings { settings in
			DispatchQueue.main.async {
				self.isAuthorized = settings.authorizationStatus == .authorized
			}
		}
	}*/
	
	// Planifie des notifications hebdomadaires jusqu'à la date de maintenance
	func scheduleWeeklyNotifications(for maintenance: Maintenance) {
		guard maintenance.reminder else { return }
		
		let calendar = Calendar.current
		let now = Date()
		var nextDate = calendar.date(byAdding: .day, value: -30, to: maintenance.date) ?? now // date de la notif 30j avant entretien
		if nextDate < now { nextDate = now }
		
		while nextDate <= maintenance.date {
			let components = calendar.dateComponents([.year, .month, .day, .hour, .minute], from: nextDate)
			
			let content = UNMutableNotificationContent()
			content.title = "Entretien à venir"
			content.body = "Votre entretien \(maintenance.maintenanceType) est prévu le \(maintenance.date.formatted(date: .numeric, time: .omitted))"
			content.sound = .default
			
			// Identifiant unique basé sur la date pour chaque notif hebdo
			let identifier = "\(maintenance.maintenanceType.id)-\(nextDate.timeIntervalSince1970)" //création id différents : timeIntervalSince1970 renvoie le nombre de secondes depuis le 1er janvier 1970 -> permet de planifier plusierus maintenance sur la meme maintenance
			
			let trigger = UNCalendarNotificationTrigger(dateMatching: components, repeats: false)
			let request = UNNotificationRequest(identifier: identifier, content: content, trigger: trigger)
			
			UNUserNotificationCenter.current().add(request) { error in
				if let error = error {
					print("Erreur planification notification: \(error)")
				}
			}
			
			// Passe à la semaine suivante
			nextDate = calendar.date(byAdding: .weekOfYear, value: 1, to: nextDate)!
		}
	}
	
	// Annule toutes les notifications liées à une maintenance
	func cancelWeeklyNotifications(for maintenance: Maintenance) {
		UNUserNotificationCenter.current().getPendingNotificationRequests { requests in
			let idsToCancel = requests
				.filter { $0.identifier.starts(with: maintenance.maintenanceType.id) }
				.map { $0.identifier }
			UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: idsToCancel)
		}
	}
	
	// Met à jour le reminder : planifie ou annule
	/*func updateReminder(for maintenance: Maintenance, value: Bool) {
		if value {
			scheduleWeeklyNotifications(for: maintenance)
		} else {
			cancelWeeklyNotifications(for: maintenance)
		}
	}*/
	
	/*func checkNotificationAuthorization(using maintenanceVM: MaintenanceVM) {
		UNUserNotificationCenter.current().getNotificationSettings { settings in
			DispatchQueue.main.async {
				let isAuthorizedNow = settings.authorizationStatus == .authorized
				if isAuthorizedNow {
					// Planifier toutes les notifications pour les maintenances avec reminder = true
					NotificationManager.shared.scheduleAllReminders(using: maintenanceVM)
				} else {
					// Supprimer toutes les notifications planifiées
					NotificationManager.shared.cancelAllNotifications(using: maintenanceVM)
				}
			}
		}
	}*/
	
	func cancelAllNotifications(using maintenanceVM: MaintenanceVM) {
		for maintenance in maintenanceVM.maintenances {
			cancelWeeklyNotifications(for: maintenance)
		}
	}
	
	// Planifie toutes les notifications pour toutes les maintenances avec reminder = true
	func scheduleAllReminders(using maintenanceVM: MaintenanceVM) {
		for maintenance in maintenanceVM.maintenances {
			if maintenance.reminder {
				scheduleWeeklyNotifications(for: maintenance)
			}
		}
	}
}
