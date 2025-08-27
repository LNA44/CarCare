//
//  AddMaintenanceView.swift
//  CarCare
//
//  Created by Ordinateur elena on 16/08/2025.
//

import SwiftUI

struct AddMaintenanceView: View {
	@EnvironmentObject var maintenanceVM: MaintenanceVM
	@Binding var showingSheet: Bool
	
	var body: some View {
		VStack(spacing: 20) {
			Text("Maintenance effectuée")
			VStack {
				Text("Type")
				Picker("Type", selection: $maintenanceVM.selectedMaintenanceType) {
					ForEach(MaintenanceType.allCases) { maintenanceType in
						Text(maintenanceType.rawValue).tag(maintenanceType)
					}
				}
				.pickerStyle(MenuPickerStyle())
				
				DatePicker(
					"Date de maintenance",
					selection: $maintenanceVM.selectedMaintenanceDate,  // binding vers une Date
					displayedComponents: [.date]         // on peut choisir date, heure ou les deux
				)
				.datePickerStyle(.compact)
			}
			
			Button(action: {
				maintenanceVM.addMaintenance()
				showingSheet = false // ferme la sheet
			}) {
				Text("Ajouter l'entretien")
					.frame(maxWidth: .infinity)
					.padding()
					.background(Color.blue.cornerRadius(10))
					.foregroundColor(.white)
					.padding(.horizontal)
			}
		}
		.alert(isPresented: $maintenanceVM.showAlert) {
			Alert(
				title: Text("Erreur"),
				message: Text(maintenanceVM.error?.errorDescription ?? "Erreur inconnue"),
				dismissButton: .default(Text("OK")) {
					maintenanceVM.showAlert = false
					maintenanceVM.error = nil
				}
			)
		}
	}
}

/*#Preview {
	AddMaintenanceView(viewModel: DashboardVM())
}
*/
