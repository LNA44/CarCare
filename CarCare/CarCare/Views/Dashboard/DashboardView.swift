//
//  DashboardView.swift
//  CarCare
//
//  Created by Ordinateur elena on 22/07/2025.
//

import SwiftUI

struct DashboardView: View {
	@ObservedObject var bikeVM: BikeVM
	@ObservedObject var maintenanceVM: MaintenanceVM
	@StateObject private var VM: DashboardVM
	@State private var goToAdd = false

	let formatter: DateFormatter = {
		let df = DateFormatter()
		df.dateStyle = .medium
		df.timeStyle = .none
		return df
	}()
	
	init(bikeVM: BikeVM, maintenanceVM: MaintenanceVM) {
		self.bikeVM = bikeVM
		self.maintenanceVM = maintenanceVM
		_VM = StateObject(wrappedValue: DashboardVM(maintenanceVM: maintenanceVM))
	}
	
	var body: some View {
		ScrollView {
			VStack(spacing: 20) {
				Text("Mon vélo")
					.font(.custom("SpaceGrotesk-Bold", size: 22))
				
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
						
						Text("\(maintenanceVM.overallStatus.label)")
							.font(.custom("SpaceGrotesk-Bold", size: 24))
							.foregroundColor(maintenanceVM.overallStatus.label == "À jour" ? .green : .red)
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
						.frame(width: 380, height: 250)
						.cornerRadius(10)
						.scaledToFit()
					
					VStack(alignment: .leading) {
						Text("Dernier entretien")
							.font(.custom("SpaceGrotesk-Bold", size: 22))
							.padding(.bottom, 5)
						
							Text("\(VM.generalLastMaintenance?.maintenanceType.rawValue ?? "")")
								.font(.custom("SpaceGrotesk-Bold", size: 16))
							
							if let date = VM.generalLastMaintenance?.date {
								Text(formatter.string(from: date))
									.font(.custom("SpaceGrotesk-Bold", size: 16))
							} else {
								Text("Pas de date")
									.font(.custom("SpaceGrotesk-Bold", size: 16))
							}
					}
					.foregroundColor(.white)
					.bold()
					.padding(.vertical, 10)
					.frame(width: 350, height: 250, alignment: .bottomLeading)
					
				}
				.padding(10)
				
				NavigationLink(
					destination: BikeModificationsView(bikeVM: bikeVM)
				) {
					Text("Modifier les infos du vélo")
						.font(.custom("SpaceGrotesk-Bold", size: 16))
						.foregroundColor(.black)
						.frame(maxWidth: .infinity)
						.padding()
						.background(Color("InputSurfaceColor"))
						.cornerRadius(10)
				}
				.padding(.horizontal, 10)
				
				NavigationLink(
					destination: AddMaintenanceView(maintenanceVM: maintenanceVM, onAdd: {
						VM.fetchLastMaintenance() //closure appelée après dismiss
					}),
					isActive: $goToAdd
				) {
					Text("Ajouter un entretien")
						.font(.custom("SpaceGrotesk-Bold", size: 16))
						.foregroundColor(.white)
						.frame(maxWidth: .infinity)
						.padding()
						.background(Color("AppPrimaryColor"))
						.cornerRadius(10)
				}
				.padding(.bottom, 40)
				.padding(.horizontal, 10)
			}
			.navigationBarBackButtonHidden(true)
			.onAppear {
				bikeVM.fetchBikeData() //bikeData mises dans publised
				VM.fetchLastMaintenance()
				maintenanceVM.fetchAllMaintenance() //utile pour statut général entretien
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

/*#Preview {
    DashboardView()
}
*/
