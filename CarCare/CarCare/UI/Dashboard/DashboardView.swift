//
//  DashboardView.swift
//  CarCare
//
//  Created by Ordinateur elena on 22/07/2025.
//

import SwiftUI

struct DashboardView: View {
	@StateObject var viewModel = DashboardVM()
	
	let formatter: DateFormatter = {
		let df = DateFormatter()
		df.dateStyle = .medium
		df.timeStyle = .none
		return df
	}()
	
	var body: some View {
		VStack(spacing: 20) {
			Text("\(viewModel.brand) \(viewModel.model) (\(viewModel.year))")
				.font(.largeTitle)
				.bold()
				.padding(.top)
			
			Text("\(viewModel.mileage)")
			
			VStack(alignment: .leading, spacing: 5) {
				Text("Dernier entretien")
					.font(.headline)
				HStack {
					Text("\(viewModel.lastMaintenance?.maintenanceType ?? .Unknown)")
						
					if let date = viewModel.lastMaintenance?.date {
						Text(formatter.string(from: date))
					} else {
						Text("Pas de date")
					}
				}
				.font(.subheadline)
				.foregroundColor(.gray)
			}
			.frame(maxWidth: .infinity, alignment: .leading)
			.padding(.horizontal)
			
			VStack(alignment: .leading, spacing: 10) {
				Text("Entretiens à venir")
					.font(.headline)
				
				/*if viewModel.upcomingMaintenances.isEmpty {
					Text("Aucun entretien à venir")
						.foregroundColor(.gray)
				} else {
					ForEach(viewModel.upcomingMaintenances) { entretien in
						HStack {
							Text(entretien.title)
							Spacer()
							Text(dateFormatter.string(from: entretien.date))
								.foregroundColor(.gray)
								.font(.subheadline)
						}
						.padding(.horizontal)
					}
				}*/
			}
			.frame(maxWidth: .infinity, alignment: .leading)
			
			Spacer()
			
			// Bouton ajouter un entretien
			Button(action: {
				//viewModel.addMaintenance()
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
		.navigationBarBackButtonHidden(true)
	}
}

#Preview {
    DashboardView()
}
