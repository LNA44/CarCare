//
//  Maintenance_FollowUpView.swift
//  CarCare
//
//  Created by Ordinateur elena on 22/07/2025.
//

import SwiftUI

struct MaintenanceView: View {
	@ObservedObject var maintenanceVM: MaintenanceVM
	@StateObject private var VM: MaintenanceViewVM

	var lastMaintenanceByType: [MaintenanceType: Maintenance] {
		Dictionary(
			grouping: maintenanceVM.maintenances,
			by: { $0.maintenanceType }
		).compactMapValues { maintenances in
			maintenances.max(by: { $0.date < $1.date }) // garde la dernière
		}
		.filter { $0.key != .Unknown } // on enlève Unknown
	}

	//MARK: -Initialization
	init(maintenanceVM: MaintenanceVM) {
		self.maintenanceVM = maintenanceVM
		_VM = StateObject(wrappedValue: MaintenanceViewVM(maintenanceVM: maintenanceVM))
	}
	//MARK: -Body
	var body: some View {
		let sortedKeys = VM.sortedMaintenanceKeys(from: maintenanceVM.maintenances)
		VStack(spacing: 20) {
			VStack {
				List {
					Section(header: Text("Entretiens à venir")
						.font(.custom("SpaceGrotesk-Bold", size: 18))
						.textCase(nil)) {
							ForEach(sortedKeys, id: \.self) { type in
								if let maintenance = lastMaintenanceByType[type] {
									NavigationLink(destination: MaintenanceDetailsView(VM: VM, maintenanceVM: maintenanceVM, maintenanceID: maintenance.id)) {
										ToDoMaintenanceRow(VM: VM, maintenanceType: type)
									}
								}
							}
						}
					Section(header: Text("Terminé")
						.font(.custom("SpaceGrotesk-Bold", size: 18))
						.textCase(nil)) {
							ForEach(maintenanceVM.maintenances.reversed(), id: \.self) { maintenance in
								DoneMaintenanceRow(maintenance: maintenance)
							}
						}
				}
			}
			NavigationLink(destination: MaintenanceHistoryView()) {
				Text("Historique des entretiens (\(VM.calculateNumberOfMaintenance()))")
			}
			Spacer()
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
    MaintenanceView()
}
*/

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
