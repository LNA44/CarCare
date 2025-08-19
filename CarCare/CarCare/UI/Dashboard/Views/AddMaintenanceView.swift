//
//  AddMaintenanceView.swift
//  CarCare
//
//  Created by Ordinateur elena on 16/08/2025.
//

import SwiftUI

struct AddMaintenanceView: View {
	@ObservedObject var viewModel: DashboardVM
	@Binding var showingSheet: Bool
	
    var body: some View {
        Text("Maintenance effectuée")
		
		Text("Type")
		Picker("Type", selection: $viewModel.selectedMaintenanceType) {
			ForEach(MaintenanceType.allCases) { maintenanceType in
				Text(maintenanceType.rawValue).tag(maintenanceType)
			}
		}
		.pickerStyle(MenuPickerStyle())
		
		DatePicker(
			"Date de maintenance",
			selection: $viewModel.selectedMaintenanceDate,  // binding vers une Date
			displayedComponents: [.date]         // on peut choisir date, heure ou les deux
		)
		.datePickerStyle(.compact)
		
		Button(action: {
			viewModel.addMaintenance()
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
}

/*#Preview {
	AddMaintenanceView(viewModel: DashboardVM())
}
*/
