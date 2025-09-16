//
//  MaintenanceRow.swift
//  CarCare
//
//  Created by Ordinateur elena on 19/08/2025.
//

import SwiftUI

struct ToDoMaintenanceRow: View {
	@ObservedObject var VM: MaintenanceViewVM
	let maintenanceType: MaintenanceType?
	let formatter: DateFormatter = {
		let df = DateFormatter()
		df.dateStyle = .medium
		df.timeStyle = .none
		df.locale = Locale.current  
		return df
	}()
	
	var body: some View {
		if let maintenanceType = maintenanceType {
			let daysRemaining = VM.daysUntilNextMaintenance(type: maintenanceType)
			let nextDate = VM.nextMaintenanceDate(for: maintenanceType)
			
			HStack {
				VStack(alignment: .leading, spacing: 3) {
					Text("\(maintenanceType.localizedName)")
						.foregroundColor(Color("TextColor"))
						.font(.system(size: 18, weight: .bold, design: .rounded))
					
					VStack {
						if let daysRemaining = daysRemaining, daysRemaining >= 0 {
							   Text(String(format: NSLocalizedString("days_remaining_key", comment: "days remaining"), daysRemaining))
						   } else if let daysRemaining = daysRemaining, daysRemaining < 0 {
							   Text(String(format: NSLocalizedString("days_remaining_key", comment: "days remaining"), 0))
						   } else {
							   Text(NSLocalizedString("unknown_days_remaining_key", comment: "days remaining unknown"))
						   }
					}
					.foregroundColor(Color("TextColor"))
					.font(.system(size: 18, weight: .regular, design: .rounded))
				}
				
				Spacer()
				
				VStack(alignment: .trailing) {
					DaysIndicatorView(days: daysRemaining ?? 0, frequency: maintenanceType.frequencyInDays, rectangleWidth: 20, rectangleHeight: 10, triangleWidth: 5, triangleHeight: 5, spacing: 2)
					
					if let nextDate = nextDate {
						Text("\(formatter.string(from: nextDate))")
					} else {
						Text("Pas de date prévue")
					}
				}
				.foregroundColor(Color("TextColor"))
				.font(.system(size: 18, weight: .regular, design: .rounded))
			}
		}
	}
}
	
	
	/*#Preview {
	 MaintenanceRow(viewModel: <#T##MaintenanceVM#>)
	 }
	 */
