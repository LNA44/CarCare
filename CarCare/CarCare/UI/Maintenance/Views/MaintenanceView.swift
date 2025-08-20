//
//  Maintenance_FollowUpView.swift
//  CarCare
//
//  Created by Ordinateur elena on 22/07/2025.
//

import SwiftUI

struct MaintenanceView: View {
	@StateObject var viewModel = MaintenanceVM()
	var lastMaintenanceByType: [MaintenanceType: Maintenance] {
		Dictionary(
			grouping: viewModel.maintenances,
			by: { $0.maintenanceType }
		).compactMapValues { maintenances in
			maintenances.max(by: { $0.date < $1.date }) // garde la dernière
		}
		.filter { $0.key != .Unknown } // on enlève Unknown
	}
	
	//MARK: -Body
	var body: some View {
		NavigationStack {
			VStack(spacing: 20) {
				VStack {
					Text("Entretiens à venir")
					List {
						ForEach(lastMaintenanceByType.keys.sorted { $0.rawValue < $1.rawValue }, id: \.self) { type in
							if let maintenance = lastMaintenanceByType[type] {
								NavigationLink(destination: MaintenanceDetailsView(viewModel: viewModel, maintenanceID: maintenance.id)) {
									MaintenanceRow(viewModel: viewModel, maintenanceType: type)
								}
							}
						}
					}
					.onAppear {
						viewModel.fetchAllMaintenance()
					}
				}
				NavigationLink(destination: MaintenanceHistoryView()) {
					Text("Historique des entretiens (\(viewModel.calculateNumberOfMaintenance()))")
				}
				Spacer()
			}
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
