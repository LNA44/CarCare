//
//  DashboardView.swift
//  CarCare
//
//  Created by Ordinateur elena on 22/07/2025.
//

import SwiftUI

struct DashboardView: View {
	@StateObject var viewModel = DashboardVM()
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
				Text("\(viewModel.brand) \(viewModel.model) (\(viewModel.year))")
					.font(.largeTitle)
					.bold()
					.padding(.top)
					.padding(.horizontal, 15)
					.multilineTextAlignment(.center)
				
				HStack {
					Text("Entretien")
						.font(.title2)
				}
				
				Text("\(viewModel.overallMaintenanceStatus().label)")
					.font(.system(size: 20, weight: .bold))
					.foregroundColor(viewModel.overallMaintenanceStatus().label == "À jour" ? .green : .red)
				
				VStack(spacing: 5) {
					Text("Dernier entretien")
						.font(.title2)
					HStack {
						if (viewModel.lastMaintenance != nil) {
							Text("\(viewModel.lastMaintenance?.maintenanceType ?? .Unknown)")
							
							if let date = viewModel.lastMaintenance?.date {
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
				AddMaintenanceView(viewModel: viewModel, showingSheet: $showAddMaintenance)
			}
			.navigationBarBackButtonHidden(true)
			.onAppear {
				viewModel.fetchBikeData()
				viewModel.fetchLastMaintenance()
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
		
		.sheet(isPresented: $showBikeModification) {
			BikeModificationsView(viewModel: viewModel, showingSheet: $showBikeModification)
		}
	}
}

#Preview {
    DashboardView()
}
