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
	@ObservedObject var notificationVM: NotificationViewModel
	@StateObject private var VM: MaintenanceViewVM
	@State private var hasFetched = false
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
	init(bikeVM: BikeVM, maintenanceVM: MaintenanceVM, notificationVM: NotificationViewModel) {
		self.bikeVM = bikeVM
		self.maintenanceVM = maintenanceVM
		self.notificationVM = notificationVM
		_VM = StateObject(wrappedValue: MaintenanceViewVM(maintenanceVM: maintenanceVM))
	}
	
	//MARK: -Body
	var body: some View {
		let sortedKeys = VM.sortedMaintenanceKeys(from: maintenanceVM.maintenances)
		ZStack {
			Color("BackgroundColor") // fond principal
					.ignoresSafeArea()  // couvre tout l’écran
			VStack(spacing: 20) {
				VStack {
					if let lastMaintenanceByType = lastMaintenanceByType {
						List {
							Section(header: Text(NSLocalizedString("maintenances_to_come", comment: "Title for upcoming maintenance section"))
								.font(.system(size: 27, weight: .bold, design: .rounded))
								.foregroundColor(Color("TextColor"))
								.textCase(nil)) {
									ForEach(sortedKeys, id: \.self) { type in
										if let maintenance = lastMaintenanceByType[type] {
											NavigationLink(destination: MaintenanceDetailsView(bikeVM: bikeVM, maintenanceVM: maintenanceVM, maintenanceID: maintenance.id, onAdd: {
												maintenanceVM.fetchAllMaintenance(for: bikeVM.bikeType)
											}, notificationVM: notificationVM)) {
												ToDoMaintenanceRow(VM: VM, maintenanceType: type)
											}
											.listRowBackground(Color("MaintenanceHistoryColor"))
										}
									}
								}
							Section(header: Text(NSLocalizedString("completed_maintenances", comment: "Title for completed maintenance section"))
								.font(.system(size: 27, weight: .bold, design: .rounded))
								.foregroundColor(Color("TextColor"))
								.textCase(nil)) {
									ForEach(maintenanceVM.maintenances.reversed(), id: \.self) { maintenance in
										DoneMaintenanceRow(maintenance: maintenance)
											.listRowBackground(Color("MaintenanceHistoryColor"))
									}
					
									.onDelete { offsets in
										// Convertir offsets de la vue inversée en indices du tableau original
										let realOffsets = offsets.map { maintenanceVM.maintenances.count - 1 - $0 }
										
										realOffsets.forEach { index in
											let maintenance = maintenanceVM.maintenances[index]
											maintenanceVM.deleteOneMaintenance(maintenance: maintenance, bikeType: bikeVM.bikeType)
										}
									}
								}
						}
						.listStyle(.plain)
					} else {
						ZStack {
							VStack(alignment: .leading, spacing: 40) {
								
								Text(NSLocalizedString("maintenances_to_come", comment: "Title for upcoming maintenance section"))
									.font(.system(size: 27, weight: .bold, design: .rounded))
									.foregroundColor(Color("TextColor"))
								
								Text(NSLocalizedString("completed_maintenances", comment: "Title for completed maintenance section"))
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
									Text(NSLocalizedString("record_maintenance_instructions_key", comment: "Instructions pour enregistrer un entretien"))
									
									
								}
								.padding(.horizontal, 10)
								.padding(10)
								
							}
							.padding(.horizontal, 10)
							.background(Color("ToDoColor"))
							.cornerRadius(10)
							.overlay (
								RoundedRectangle(cornerRadius: 10)
									.stroke(Color.red, lineWidth: 2))
						}
					}
				}
			}
			.onAppear {
				guard !hasFetched else { return }
					hasFetched = true
					maintenanceVM.fetchAllMaintenance(for: bikeVM.bikeType)
			}
			.alert(
				isPresented: Binding(
					get: { maintenanceVM.showAlert || VM.showAlert },
					set: { newValue in
						if !newValue {
							maintenanceVM.showAlert = false
							VM.showAlert = false
						}
					}
				)
			) {
				if maintenanceVM.showAlert {
					return Alert(
						title: Text(NSLocalizedString("error_title", comment: "Title for error alert")),
						message: Text(maintenanceVM.error?.localizedDescription ?? NSLocalizedString("unknown_error", comment: "Fallback unknown error")),
						dismissButton: .default(Text("OK")) {
							maintenanceVM.showAlert = false
							maintenanceVM.error = nil
						}
					)
				} else {
					return Alert(
						title: Text(NSLocalizedString("error_title", comment: "Title for error alert")),
						message: Text(VM.error?.localizedDescription ?? NSLocalizedString("unknown_error", comment: "Fallback unknown error")),
						dismissButton: .default(Text("OK")) {
							VM.showAlert = false
							VM.error = nil
						}
					)
				}
			}
		}
	}
}

extension MaintenanceView {
	func rowView(for type: MaintenanceType) -> AnyView {
		if let lastMaintenanceByType = lastMaintenanceByType,
		   let maintenance = lastMaintenanceByType[type] {
			return AnyView(
				NavigationLink(destination: MaintenanceDetailsView(bikeVM: bikeVM, maintenanceVM: maintenanceVM, maintenanceID: maintenance.id, onAdd: {
					maintenanceVM.fetchAllMaintenance(for: bikeVM.bikeType)
				}, notificationVM: notificationVM)) {
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
