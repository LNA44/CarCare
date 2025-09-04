//
//  DashboardView.swift
//  CarCare
//
//  Created by Ordinateur elena on 22/07/2025.
//

import SwiftUI

struct DashboardView: View {
	@AppStorage("isDarkMode") private var isDarkMode = false
	@ObservedObject var bikeVM: BikeVM
	@ObservedObject var maintenanceVM: MaintenanceVM
	@StateObject private var VM: DashboardVM
	@State private var goToAdd = false
	@State private var didLoadData = false

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
			VStack(spacing: 10) {
					Image("Riding")
						.resizable()
						.frame(width: 100, height: 100)
						.clipShape(Circle())
						.shadow(color: .black.opacity(0.25), radius: 5, x: 0, y: 2)

					VStack {
						Text("\(bikeVM.brand) - \(bikeVM.model)")
							.font(.system(size: 24, weight: .bold, design: .rounded))
							.padding(.top)
							.padding(.horizontal, 15)
							.multilineTextAlignment(.center)
							.shadow(color: .black.opacity(0.25), radius: 2, x: 0, y: 2)
						
						HStack {
							Image(systemName: "birthday.cake")
								.resizable()
								.frame(width: 15, height: 15)
								.foregroundColor(.brown)
							Text("\(bikeVM.year)")
						}
						
						if !bikeVM.identificationNumber.isEmpty {
							Text("Numéro d'identification : \(bikeVM.identificationNumber)")
								.font(.system(size: 16, weight: .regular, design: .rounded))
						}
					}
					.padding(.bottom, 20)
					.foregroundColor(Color(.brown))
				
					Divider()
					.frame(width: 150)
					.padding(.bottom, 10)
				
				VStack {
					VStack(alignment: .center, spacing: 20) {
						Text("Entretien")
							.font(.system(size: 27, weight: .bold, design: .rounded))
							.foregroundColor(Color("TextColor"))
						
						Text("\(maintenanceVM.overallStatus.label)")
							.font(.system(size: 22, weight: .bold, design: .rounded))
							.foregroundColor(Color(.white))
							.padding(10)
							.background(
								maintenanceVM.overallStatus == .aJour ? Color("DoneColor") :
								   maintenanceVM.overallStatus == .bientotAPrevoir ? Color("InProgressColor") :
								   Color("ToDoColor")
							)
							.clipShape(Capsule())
							.shadow(color: .black.opacity(0.3), radius: 2, x: 0, y: 1)
					}
					.padding(.horizontal, 20)
				}
				.frame(maxWidth: .infinity, alignment: .center)
				.frame(height: 100)
				.cornerRadius(10)
				.padding(.horizontal, 10)
				.padding(.bottom, 20)

				ZStack {
						Image("Maintenance")
							.resizable()
							.frame(width: 360, height: 250)
							.cornerRadius(10)
							.scaledToFit()
						
						VStack(alignment: .leading) {
							Text("Dernier entretien")
								.font(.system(size: 22, weight: .bold, design: .rounded))
								.padding(.bottom, 5)
							
							Text("\(maintenanceVM.generalLastMaintenance?.maintenanceType.rawValue ?? "")")
								.font(.system(size: 16, weight: .bold, design: .rounded))
							
							if let date = maintenanceVM.generalLastMaintenance?.date {
								Text(formatter.string(from: date))
									.font(.system(size: 16, weight: .bold, design: .rounded))
							} else {
								Text("Pas de date")
									.font(.system(size: 16, weight: .bold, design: .rounded))
							}
						}
						.foregroundColor(.white)
						.bold()
						.padding(.horizontal, 10)
						.padding(.vertical, 10)
						.frame(width: 350, height: 250, alignment: .bottomLeading)
						
					}
					.padding(.horizontal, 10)
					.padding(.vertical, 10)
					
					VStack(spacing: 20) {
						NavigationLink(
							destination: BikeModificationsView(bikeVM: bikeVM) {
								//closure de BikeModificationsView
								maintenanceVM.deleteAllMaintenances()
							}
						) {
							Text("Modifier les infos du vélo")
								.font(.system(size: 16, weight: .bold, design: .rounded))
								.foregroundColor(Color("TextColor"))
								.frame(maxWidth: .infinity)
								.padding()
								.background(Color("BackgroundColor"))
								.background(Color.white)
								.cornerRadius(10)
						}
						.padding(.horizontal, 10)
						.shadow(color: .black.opacity(0.25), radius: 5, x: 0, y: 2)
						
						NavigationLink(
							destination: AddMaintenanceView(bikeVM: bikeVM, maintenanceVM: maintenanceVM, onAdd: {
								VM.fetchLastMaintenance(for: bikeVM.bikeType) //closure appelée après dismiss
								maintenanceVM.fetchAllMaintenance(for: bikeVM.bikeType)
							}),
							isActive: $goToAdd
						) {
							Text("Ajouter un entretien")
								.font(.system(size: 16, weight: .bold, design: .rounded))
								.foregroundColor(.white)
								.frame(maxWidth: .infinity)
								.padding()
								.background(Color("AppPrimaryColor"))
								.cornerRadius(10)
						}
						.padding(.bottom, 20)
						.padding(.horizontal, 10)
						.shadow(color: .black.opacity(0.25), radius: 5, x: 0, y: 2)
					}
					.padding(.top, 10)
				}
				.padding(.top, 20)
				.cornerRadius(15)
				.padding(.horizontal, 10)
			.navigationBarBackButtonHidden(true)
			.onAppear {
				guard !didLoadData else { return } //evite boucle lors du changement de light dark mode
				didLoadData = true
				bikeVM.fetchBikeData() { //bikeData mises dans publised
				VM.fetchLastMaintenance(for: bikeVM.bikeType)
				maintenanceVM.fetchAllMaintenance(for: bikeVM.bikeType) //utile pour statut général entretien
				}
			}
			.onChange(of: bikeVM.bikeType) { _, newValue in
				VM.fetchLastMaintenance(for: newValue)
				maintenanceVM.fetchAllMaintenance(for: newValue)
			}
		}
		.background(
				LinearGradient(
					gradient: Gradient(colors: isDarkMode
									   ? [Color.black, Color.gray]
									   : [Color("BackgroundColor"), Color.white]),
					startPoint: .top,
					endPoint: .bottom
				)
			)
		.toolbar {
			ToolbarItem(placement: .principal) {
				Text("Mon vélo")
					.font(.system(size: 22, weight: .bold, design: .rounded))
					.foregroundColor(Color("TextColor"))
			}
		}
		.background(Color("BackgroundColor"))
		.navigationBarTitleDisplayMode(.inline)
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


/*#Preview {
    DashboardView()
}
*/
