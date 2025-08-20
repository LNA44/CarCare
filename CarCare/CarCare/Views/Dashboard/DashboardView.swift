//
//  DashboardView.swift
//  CarCare
//
//  Created by Ordinateur elena on 22/07/2025.
//

import SwiftUI

struct DashboardView: View {
	@EnvironmentObject var bikeVM: BikeVM
	@EnvironmentObject var maintenanceVM: MaintenanceVM
	@State private var showAddMaintenance = false
	@State private var showBikeModification = false
	
	let formatter: DateFormatter = {
		let df = DateFormatter()
		df.dateStyle = .medium
		df.timeStyle = .none
		return df
	}()
	
	var body: some View {
		NavigationStack {
			VStack(spacing: 40) {
				Text("\(bikeVM.brand) \(bikeVM.model) (\(bikeVM.year))")
					.font(.largeTitle)
					.bold()
					.padding(.top)
					.padding(.horizontal, 15)
					.multilineTextAlignment(.center)
				
				HStack {
					Text("Entretien")
						.font(.title2)
				}
				
				Text("\(maintenanceVM.overallMaintenanceStatus().label)")
					.font(.system(size: 20, weight: .bold))
					.foregroundColor(maintenanceVM.overallMaintenanceStatus().label == "À jour" ? .green : .red)
				
				VStack(spacing: 5) {
					Text("Dernier entretien")
						.font(.title2)
					HStack {
						if (maintenanceVM.lastMaintenance != nil) {
							Text("\(maintenanceVM.lastMaintenance?.maintenanceType ?? .Unknown)")
							
							if let date = maintenanceVM.lastMaintenance?.date {
								Text(formatter.string(from: date))
							} else {
								Text("Pas de date")
							}
						} else {
							Text("Pas d'entretien réalisé")
						}
					}
					.foregroundColor(.gray)
				}
				.frame(maxWidth: .infinity, alignment: .center)
				.padding(.horizontal)
				
				Spacer()
				
				Button(action: {
					showAddMaintenance = true
				}) {
					Text("Ajouter un entretien")
						.frame(maxWidth: .infinity)
						.padding()
						.background(Color.blue.cornerRadius(10))
						.foregroundColor(.white)
						.padding(.horizontal)
				}
				.padding(.bottom)
			}
			.sheet(isPresented: $showAddMaintenance) {
				AddMaintenanceView(showingSheet: $showAddMaintenance)
			}
			.sheet(isPresented: $showBikeModification) {
				BikeModificationsView(showingSheet: $showBikeModification)
			}
			.navigationBarBackButtonHidden(true)
			.onAppear {
				bikeVM.fetchBikeData()
				maintenanceVM.fetchLastMaintenance()
			}
			.toolbar {
				ToolbarItem(placement: .navigationBarTrailing) {
					Button(action: {
						showBikeModification = true
					}) {
						Image(systemName: "slider.horizontal.3")
					}
				}
			}
		}
	}
}

#Preview {
    DashboardView()
}
