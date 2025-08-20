//
//  MaintenanceRow.swift
//  CarCare
//
//  Created by Ordinateur elena on 19/08/2025.
//

import SwiftUI

struct MaintenanceRow: View {
	@StateObject var viewModel: MaintenanceVM
	let maintenanceType: MaintenanceType

    var body: some View {
		let daysRemaining = viewModel.daysUntilNextMaintenance(type: maintenanceType)
		let nextDate = viewModel.nextMaintenanceDate(for: maintenanceType)
		
		VStack(alignment: .leading) {
			HStack {
				Text("\(maintenanceType.rawValue)")
					.bold()
				
				Spacer()
				DaysIndicatorView(days: daysRemaining, rectangleWidth: 20, rectangleHeight: 10, triangleWidth: 5, triangleHeight: 5, spacing: 2)
			}
			
			if let nextDate = nextDate {
				Text("Prochaine maintenance prévue le \(nextDate.formatted(date: .abbreviated, time: .omitted))")
			} else {
				Text("Pas encore réalisée")
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
