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
				VStack(alignment: .leading) {
					Image(systemName: "triangle.fill")
						.resizable()
						.frame(width: 10, height: 5)
						.rotationEffect(.degrees(180))
						.foregroundColor(.black)
						.offset(x: triangleOffset(for: daysRemaining))
					HStack {
						Rectangle()
							.fill(colorFirstRectangle(for: daysRemaining))
							.frame(width: 20, height: 10)
						
						Rectangle()
							.fill(colorSecondRectangle(for: daysRemaining))
							.frame(width: 20, height: 10)
						
						Rectangle()
							.fill(colorThirdRectangle(for: daysRemaining))
							.frame(width: 20, height: 10)
					}
				}
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

extension MaintenanceRow {
	func colorFirstRectangle(for days: Int?) -> Color {
		guard let days else { return .gray }
		switch days {
		case let x where x > 30: return .green
		case 1...30: return .gray
		case ..<1: return .gray
		default: return .gray
		}
	}
	
	func colorSecondRectangle(for days: Int?) -> Color {
		guard let days else { return .gray }
		switch days {
		case let x where x > 30: return .gray
		case 1...30: return .orange
		case ..<1: return .gray
		default: return .gray
		}
	}
	
	func colorThirdRectangle(for days: Int?) -> Color {
		guard let days else { return .gray }
		switch days {
		case let x where x > 30: return .gray
		case 1...30: return .gray
		case ..<1: return .red
		default: return .gray
		}
	}
	
	func triangleOffset(for days: Int?) -> CGFloat {
		guard let days else { return 0 }
		switch days {
		case let x where x > 30: return 0       // triangle au-dessus du premier rectangle
		case 1...30: return 25                  // décalage pour le deuxième rectangle
		case ..<1: return 50                   // décalage pour le troisième rectangle
		default: return 0
		}
	}
}

/*#Preview {
    MaintenanceRow(viewModel: <#T##MaintenanceVM#>)
}
*/
