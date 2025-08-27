//
//  Maintenance_FollowUpView.swift
//  CarCare
//
//  Created by Ordinateur elena on 22/07/2025.
//

import SwiftUI

struct MaintenanceView: View {
	@EnvironmentObject var maintenanceVM: MaintenanceVM
	var lastMaintenanceByType: [MaintenanceType: Maintenance] {
		Dictionary(
			grouping: maintenanceVM.maintenances,
			by: { $0.maintenanceType }
		).compactMapValues { maintenances in
			maintenances.max(by: { $0.date < $1.date }) // garde la dernière
		}
		.filter { $0.key != .Unknown } // on enlève Unknown
	}

	//MARK: -Body
	var body: some View {
		let sortedKeys: [MaintenanceType] = Array(lastMaintenanceByType.keys).sorted { $0.rawValue < $1.rawValue }
		NavigationStack {
			VStack(spacing: 20) {
				VStack {
					Text("Entretiens à venir")
					List {
						ForEach(sortedKeys, id: \.self) { type in
							if let maintenance = lastMaintenanceByType[type] {
								NavigationLink(destination: MaintenanceDetailsView(maintenanceID: maintenance.id)) {
									MaintenanceRow(maintenanceType: type)
								}
							}
						}
					}
					.onAppear {
						maintenanceVM.fetchAllMaintenance()
					}
				}
				NavigationLink(destination: MaintenanceHistoryView()) {
					Text("Historique des entretiens (\(maintenanceVM.calculateNumberOfMaintenance()))")
				}
				Spacer()
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

#Preview {
    MaintenanceView()
}


/*List {
	ForEach(viewModel.categories.keys.sorted(), id: \.self) { key in
		CategoryRow(categoryName: key, items: viewModel.categories[key] ?? [], selectedProduct: $selectedProduct)
			.listRowBackground(Color.clear)
	}
	.frame(height: 390)
	.listRowSeparator(.hidden)
	.listRowInsets(EdgeInsets())
}
.background(Color("Background"))
.listStyle(PlainListStyle())
.onAppear {
	Task {
		await viewModel.fetchProducts()
	}
}
*/
