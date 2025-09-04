//
//  Maintenance_FollowUpView.swift
//  CarCare
//
//  Created by Ordinateur elena on 22/07/2025.
//

import SwiftUI

struct MaintenanceView: View {
	@ObservedObject var bikeVM: BikeVM
	@ObservedObject var maintenanceVM: MaintenanceVM
	@StateObject private var VM: MaintenanceViewVM

	var lastMaintenanceByType: [MaintenanceType: Maintenance]? {
		guard !maintenanceVM.maintenances.isEmpty else { return nil }
		return Dictionary(
			grouping: maintenanceVM.maintenances,
			by: { $0.maintenanceType }
		).compactMapValues { maintenances in
			maintenances.max(by: { $0.date < $1.date }) // garde la dernière
		}
		.filter { $0.key != .Unknown } // on enlève Unknown
	}

	//MARK: -Initialization
	init(bikeVM: BikeVM, maintenanceVM: MaintenanceVM) {
		self.bikeVM = bikeVM
		self.maintenanceVM = maintenanceVM
		_VM = StateObject(wrappedValue: MaintenanceViewVM(maintenanceVM: maintenanceVM))
	}
	
	//MARK: -Body
	var body: some View {
		let sortedKeys = VM.sortedMaintenanceKeys(from: maintenanceVM.maintenances)

		VStack(spacing: 20) {
			VStack {
				if let lastMaintenanceByType = lastMaintenanceByType {
					List {
						Section(header: Text("Entretiens à venir")
							.font(.system(size: 27, weight: .bold, design: .rounded))
							.foregroundColor(Color("TextColor"))
							.textCase(nil)) {
								ForEach(sortedKeys, id: \.self) { type in
									if let maintenance = lastMaintenanceByType[type] {
										NavigationLink(destination: MaintenanceDetailsView(bikeVM: bikeVM, maintenanceVM: maintenanceVM, maintenanceID: maintenance.id)) {
											ToDoMaintenanceRow(VM: VM, maintenanceType: type)
										}
									}
								}
							}
						Section(header: Text("Terminés")
							.font(.system(size: 27, weight: .bold, design: .rounded))
							.foregroundColor(Color("TextColor"))
							.textCase(nil)) {
								ForEach(maintenanceVM.maintenances.reversed(), id: \.self) { maintenance in
									DoneMaintenanceRow(maintenance: maintenance)
								}
							}
					}
				} else {
					ZStack {
						VStack(alignment: .leading, spacing: 40) {
							
							Text("Entretiens à venir")
								.font(.system(size: 27, weight: .bold, design: .rounded))
								.foregroundColor(Color("TextColor"))
							
							Text("Terminés")
								.font(.system(size: 27, weight: .bold, design: .rounded))
								.foregroundColor(Color("TextColor"))
							Spacer()
						}
						.frame(maxWidth: .infinity, alignment: .leading)
						.padding(.top, 20)
						.padding(.leading, 10)
						
						VStack {
							HStack(spacing: 10) {
								Image(systemName: "exclamationmark.triangle.fill")
								Text("Enregistrez un entretien réalisé de chez catégorie pour voir les prochains entretiens à venir et l'historique.")
									
							}
							.padding(.horizontal, 10)
							.padding(10)
							.overlay (
								RoundedRectangle(cornerRadius: 10)
									.stroke(Color.red, lineWidth: 2))
						}
						.background(Color("ToDoColor"))
						.cornerRadius(10)
					}
				}
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
		.alert(isPresented: $VM.showAlert) {
			Alert(
				title: Text("Erreur"),
				message: Text(VM.error?.errorDescription ?? "Erreur inconnue"),
				dismissButton: .default(Text("OK")) {
					VM.showAlert = false
					VM.error = nil
				}
			)
		}
	}
}

extension MaintenanceView {
	func rowView(for type: MaintenanceType) -> AnyView {
		if let lastMaintenanceByType = lastMaintenanceByType,
		   let maintenance = lastMaintenanceByType[type] {
			return AnyView(
				NavigationLink(destination: MaintenanceDetailsView(bikeVM: bikeVM, maintenanceVM: maintenanceVM, maintenanceID: maintenance.id)) {
					ToDoMaintenanceRow(VM: VM, maintenanceType: type)
				}
			)
		} else {
			return AnyView(
				ToDoMaintenanceRow(VM: VM,maintenanceType: nil)
			)
		}
	}
}

/*#Preview {
    MaintenanceView()
}
*/
