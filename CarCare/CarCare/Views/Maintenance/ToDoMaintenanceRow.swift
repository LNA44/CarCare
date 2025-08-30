//
//  MaintenanceRow.swift
//  CarCare
//
//  Created by Ordinateur elena on 19/08/2025.
//

import SwiftUI

struct ToDoMaintenanceRow: View {
	@EnvironmentObject var maintenanceVM: MaintenanceVM
	let maintenanceType: MaintenanceType
	let formatter: DateFormatter = {
		let df = DateFormatter()
		df.dateFormat = "dd/MM/yyyy" // jour/mois/année
		return df
	}()

    var body: some View {
		let daysRemaining = maintenanceVM.daysUntilNextMaintenance[maintenanceType] ?? nil
		let nextDate = maintenanceVM.nextMaintenanceDates[maintenanceType] ?? nil
		
		VStack(alignment: .leading) {
			HStack {
				Text("\(maintenanceType.rawValue)")
					.bold()
				
				Spacer()
				DaysIndicatorView(days: daysRemaining, rectangleWidth: 20, rectangleHeight: 10, triangleWidth: 5, triangleHeight: 5, spacing: 2)
			}
			
			if let nextDate = nextDate {
				Text("\(formatter.string(from: nextDate))")
			} else {
				Text("Pas de date prévue")
			}

			if let daysRemaining = daysRemaining, daysRemaining >= 0 {
				Text("\(daysRemaining) jours restants")
			} else if let daysRemaining = daysRemaining, daysRemaining < 0 {
				Text("0 jour restant")
			} else {
				Text("Nombre de jours restants inconnu")
			}
		}
	}
}


/*#Preview {
    MaintenanceRow(viewModel: <#T##MaintenanceVM#>)
}
*/
