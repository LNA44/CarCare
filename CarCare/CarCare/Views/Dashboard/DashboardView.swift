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
		ScrollView {
			VStack(spacing: 20) {
				Text("Mon vélo")
					.font(.custom("SpaceGrotesk-Bold", size: 20))
				
				Image("Riding")
					.resizable()
					.frame(width: 100, height: 100)
					.clipShape(Circle())
				
				VStack {
					Text("\(bikeVM.brand) \(bikeVM.model) (\(bikeVM.year))")
						.font(.custom("SpaceGrotesk-Bold", size: 16))
						.bold()
						.padding(.top)
						.padding(.horizontal, 15)
						.multilineTextAlignment(.center)
					
					if !bikeVM.identificationNumber.isEmpty {
						Text("Numéro d'identification : \(bikeVM.identificationNumber)")
							.font(.custom("SpaceGrotesk-Bold", size: 16))
					}
				}
				.padding(.bottom, 20)
				.foregroundColor(Color(.brown))
				
				VStack {
					VStack(alignment: .leading, spacing: 10) {
						Text("Entretien")
							.font(.custom("SpaceGrotesk-Regular", size: 16))
						
						Text("\(maintenanceVM.overallMaintenanceStatus().label)")
							.font(.custom("SpaceGrotesk-Bold", size: 24))
							.foregroundColor(maintenanceVM.overallMaintenanceStatus().label == "À jour" ? .green : .red)
					}
					.padding(.horizontal, 20)
				}
				.frame(maxWidth: .infinity, alignment: .leading)
				.frame(height: 100)
				.background(Color("InputSurfaceColor"))
				.cornerRadius(10)
				.padding(.horizontal, 10)
				
				ZStack {
					Image("Maintenance")
						.resizable()
						.frame(width: 370, height: 250)
						.cornerRadius(10)
						.scaledToFit()
					
					VStack(alignment: .leading) {
						Text("Dernier entretien")
							.font(.custom("SpaceGrotesk-Bold", size: 22))
							.padding(.bottom, 5)
						
						if (maintenanceVM.lastMaintenance != nil) {
							Text("\(maintenanceVM.lastMaintenance?.maintenanceType.rawValue ?? "")")
								.font(.custom("SpaceGrotesk-Bold", size: 16))
							
							if let date = maintenanceVM.lastMaintenance?.date {
								Text(formatter.string(from: date))
									.font(.custom("SpaceGrotesk-Bold", size: 16))
							} else {
								Text("Pas de date")
									.font(.custom("SpaceGrotesk-Bold", size: 16))
							}
						} else {
							Text("Pas d'entretien réalisé")
								.font(.custom("SpaceGrotesk-Bold", size: 16))
						}
					}
					.foregroundColor(.white)
					.bold()
					.padding(.vertical, 10)
					.frame(width: 350, height: 250, alignment: .bottomLeading)
					
				}
				.padding(10)
				
				/*Button(action: {
				 showBikeModification = true
				 }) {
				 Text("Modifier les infos du vélo")
				 .frame(maxWidth: .infinity)
				 .padding()
				 .background(Color("InputSurfaceColor"))
				 .cornerRadius(10)
				 .foregroundColor(.black)
				 .font(.custom("SpaceGrotesk-Bold", size: 16))
				 }*/
				
				PrimaryButton(title: "Modifier les infos du vélo", font: .custom("SpaceGrotesk-Bold", size: 16), foregroundColor: .black, backgroundColor: Color("InputSurfaceColor")) {
					showBikeModification = true
				}
				.padding(.horizontal, 10)
				
				/*Button(action: {
				 showAddMaintenance = true
				 }) {
				 Text("Ajouter un entretien")
				 .frame(maxWidth: .infinity)
				 .padding()
				 .background(Color("PrimaryColor"))
				 .cornerRadius(10)
				 .foregroundColor(.white)
				 .font(.custom("SpaceGrotesk-Bold", size: 16))
				 
				 }*/
				
				PrimaryButton(title: "Ajouter un entretien", font: .custom("SpaceGrotesk-Bold", size: 16), foregroundColor: .white, backgroundColor: Color("PrimaryColor")) {
					showAddMaintenance = true
				}
				.padding(.bottom, 40)
				.padding(.horizontal, 10)
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
		}
		.alert(isPresented: $bikeVM.showAlert) {
			Alert(
				title: Text("Erreur liée au vélo"),
				message: Text(bikeVM.error?.errorDescription ?? "Erreur inconnue"),
				dismissButton: .default(Text("OK")) {
					bikeVM.showAlert = false
					bikeVM.error = nil
				}
			)
		}
		.alert(isPresented: $maintenanceVM.showAlert) {
			Alert(
				title: Text("Erreur liée aux entretiens"),
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
    DashboardView()
}
