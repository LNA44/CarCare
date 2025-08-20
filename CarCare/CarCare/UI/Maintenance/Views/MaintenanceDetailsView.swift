//
//  MaintenanceDetailsView.swift
//  CarCare
//
//  Created by Ordinateur elena on 19/08/2025.
//

import SwiftUI

struct MaintenanceDetailsView: View {
	@Environment(\.dismiss) private var dismiss
	@ObservedObject var viewModel: MaintenanceVM
	let maintenanceID: UUID // on reçoit juste l'ID
	var maintenance: Maintenance? { // computed property : on retrouve la "vraie" donnée à partir du viewModel
		viewModel.maintenances.first(where: { $0.id == maintenanceID })
	}
	
	var body: some View {
		if let maintenance = maintenance {
			let daysRemaining = viewModel.daysUntilNextMaintenance(type: maintenance.maintenanceType)
			
			VStack {
				Text("\(maintenance.maintenanceType)")
				DaysIndicatorView(days: daysRemaining, rectangleWidth: 40, rectangleHeight: 20, triangleWidth: 10, triangleHeight: 10, spacing: 4)
				Text("\(message(for: daysRemaining))")
				
				HStack {
					Text("Fréquence : \(maintenance.maintenanceType.readableFrequency)")
					
					Toggle("", isOn: Binding(
						get: { maintenance.reminder }, //appelé lors du dessin de la vue (aussi après modif du toggle pour redessiner la vue)
						set: { newValue in //modification du toggle
							viewModel.updateReminder(for: maintenance, value: newValue)
							//viewModel.fetchAllMaintenance()
						}
					))
					.labelsHidden()
				}
				
			}
			.navigationBarBackButtonHidden(true)
			.toolbar {
				ToolbarItem(placement: .navigationBarLeading) {
					Button("Retour") {
						dismiss()
					}
				}
			}
		} else {
			Text("Maintenance introuvable")
		}
	}
}

extension MaintenanceDetailsView {
	func message(for days: Int?) -> String {
		guard let days else { return "Nombre de jours inconnu" }
		
		switch days {
		case ..<1:
			return "C'est l'heure! Pense à prendre rendez-vous chez le réparateur le plus proche"
		case 1...30:
			return "Tu n'as pas encore à t'en préoccuper"
		default:
			return "Tu es à jour"
		}
	}
}

/*#Preview {
    MaintenanceDetailsView()
}*/
