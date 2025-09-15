//
//  NotificationManager.swift
//  CarCare
//
//  Created by Ordinateur elena on 25/08/2025.
//

import Foundation
import UserNotifications
import Combine
//notifications locales

protocol NotificationManagerProtocol {
	var notificationErrorPublisher: AnyPublisher<Error?, Never> { get }
	func requestAuthorization(completion: @escaping (Result<Void, AppError>) -> Void)
	func scheduleAllReminders(using maintenanceVM: MaintenanceVM)
	func cancelAllNotifications(using maintenanceVM: MaintenanceVM)
	func scheduleWeeklyNotifications(for maintenance: Maintenance)
	func cancelWeeklyNotifications(for maintenance: Maintenance)
}

class NotificationManager: NotificationManagerProtocol {
	static let shared = NotificationManager()
	@Published var isAuthorized: Bool = false
	@Published var notificationError: Error?
	
		var notificationErrorPublisher: AnyPublisher<Error?, Never> { //utile car protocole ne peut pas exposer $notificationError (créé par published) directement
			$notificationError.eraseToAnyPublisher()
		}
	
	private init() {}
	
	func requestAuthorization(completion: @escaping (Result<Void, AppError>) -> Void) {
		UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
			if let error = error {
				completion(.failure(.notificationError(error)))
				return
			}
			completion(granted ? .success(()) : .failure(.notificationNotAuthorized))
		}
	}
	
	// Planifie des notifications hebdomadaires jusqu'à la date de maintenance
	func scheduleWeeklyNotifications(for maintenance: Maintenance) {
		guard maintenance.reminder else { return }
		
		let dates = generateNotificationDates(for: maintenance)
		for date in dates {
			scheduleNotification(for: maintenance, on: date)
		}
	}

	// Génère toutes les dates de notification hebdomadaires
	private func generateNotificationDates(for maintenance: Maintenance) -> [Date] {
		let calendar = Calendar.current
		let now = Date()
		var dates: [Date] = []
		
		var nextDate = calendar.date(byAdding: .day, value: -30, to: maintenance.date) ?? now
		if nextDate < now { nextDate = now }
		
		while nextDate <= maintenance.date {
			dates.append(nextDate)
			nextDate = calendar.date(byAdding: .weekOfYear, value: 1, to: nextDate)!
			//nextDate = calendar.date(byAdding: .second, value: 10, to: nextDate)!
		}
		
		return dates
	}

	// Crée et planifie une notification pour une date donnée
	private func scheduleNotification(for maintenance: Maintenance, on date: Date) {
		let content = buildNotificationContent(for: maintenance)
		let identifier = buildNotificationIdentifier(for: maintenance, date: date)
		let trigger = buildNotificationTrigger(for: date)
		
		let request = UNNotificationRequest(identifier: identifier, content: content, trigger: trigger)
		
		UNUserNotificationCenter.current().add(request) { error in
			if let error = error {
				DispatchQueue.main.async {
					self.notificationError = error
				}
			}
		}
	}

	// Contenu de la notification
	private func buildNotificationContent(for maintenance: Maintenance) -> UNMutableNotificationContent {
		let content = UNMutableNotificationContent()
		content.title = "Entretien à venir"
		content.body = "Votre entretien \(maintenance.maintenanceType) est prévu le \(maintenance.date.formatted(date: .numeric, time: .omitted))"
		content.sound = .default
		return content
	}

	// Identifiant unique pour chaque notification
	private func buildNotificationIdentifier(for maintenance: Maintenance, date: Date) -> String {
		return "\(maintenance.maintenanceType.id)-\(date.timeIntervalSince1970)"
	}

	// Déclencheur pour une date donnée
	private func buildNotificationTrigger(for date: Date) -> UNCalendarNotificationTrigger {
		let components = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute], from: date)
		return UNCalendarNotificationTrigger(dateMatching: components, repeats: false)
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
