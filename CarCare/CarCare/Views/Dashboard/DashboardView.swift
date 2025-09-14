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
		df.locale = Locale.current
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
				ZStack {
					Rectangle()
							.fill(.regularMaterial)  // blur moderne
							.frame(height: 200)
							.cornerRadius(20)
							.shadow(
									color: .black.opacity(isDarkMode ? 0.1 : 0.25),
									radius: 8,
									x: 0,
									y: 4
								)
						
					VStack {
						VStack {
							Text("\(bikeVM.brand) - \(bikeVM.model)")
								.font(.system(size: 24, weight: .bold, design: .rounded))
								.padding(.top, 40)
								.padding(.horizontal, 15)
								.multilineTextAlignment(.center)
								.shadow(color: .black.opacity(0.25), radius: 2, x: 0, y: 2)
								.padding(.bottom, 15)
							
							VStack(alignment: .leading, spacing: 8) {
								HStack(spacing: 6) {
									Image(systemName: "calendar")
									Text(String(format: NSLocalizedString("bike_year_label", comment: ""), bikeVM.year))
										.font(.system(size: 16, weight: .medium, design: .rounded))
								}
								
								if !bikeVM.identificationNumber.isEmpty {
									HStack(spacing: 6) {
										Image(systemName: "barcode")
										Text(String(
											format: NSLocalizedString("identification_number_key", comment: "Label pour le numéro d'identification du vélo"),
											bikeVM.identificationNumber
										))
										.font(.system(size: 16, weight: .regular, design: .rounded))
									}
								}
							}
							.foregroundColor(Color("BikeDescriptionColor"))
							.frame(maxWidth: .infinity, alignment: .leading)
							.padding(.horizontal, 30)
						}
						.padding(.top, 50)
					}
					.padding(.bottom, 20)
					.foregroundColor(Color(.brown))
					
					ZStack {
						Circle()
							.fill(Color.white.opacity(0.2)) // overlay léger derrière
							.frame(width: 110, height: 110)
							.offset(y: -80)
						Image("Riding")
							.resizable()
							.frame(width: 100, height: 100)
							.clipShape(Circle())
							.offset(y: -80)
							.shadow(color: .black.opacity(0.25), radius: 5, x: 0, y: 2)
					}
				}
				.padding(.top, 20)
				.padding(.horizontal, 15)
				
				
				Divider()
					.frame(width: 150)
					.padding(.top, 20)
					.padding(.bottom, 10)
				
				VStack {
					VStack(alignment: .center, spacing: 20) {
						Text(NSLocalizedString("maintenance_key", comment: ""))
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
						Text(NSLocalizedString("last_maintenance_key", comment: ""))
							.font(.system(size: 22, weight: .bold, design: .rounded))
							.padding(.bottom, 5)
						
						Text("\(maintenanceVM.generalLastMaintenance?.maintenanceType.localizedName ?? "")")
							.font(.system(size: 16, weight: .bold, design: .rounded))
						
						if let date = maintenanceVM.generalLastMaintenance?.date {
							Text(formatter.string(from: date))
								.font(.system(size: 16, weight: .bold, design: .rounded))
						} else {
							Text(NSLocalizedString("no_date_key", comment: ""))
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
						Text(NSLocalizedString("button_modify_bike_information", comment: ""))
							.font(.system(size: 16, weight: .bold, design: .rounded))
							.foregroundColor(Color("TextColor"))
							.frame(maxWidth: .infinity)
							.padding()
							.background(Color("BackgroundColor"))
							.cornerRadius(10)
							.overlay(
										RoundedRectangle(cornerRadius: 10)
											.stroke(isDarkMode ? Color.white.opacity(0.4) : Color.clear, lineWidth: 1.5)
									)
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
						Text(NSLocalizedString("button_Add_Maintenance", comment: ""))
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
				gradient: Gradient(colors: [Color("BackgroundColor"), Color("BackgroundColor2")]),
				startPoint: .top,
				endPoint: .bottom
			)
		)
		.toolbar {
			ToolbarItem(placement: .principal) {
				Text(NSLocalizedString("navigation_title_modify_bike_key", comment: ""))
					.font(.system(size: 22, weight: .bold, design: .rounded))
					.foregroundColor(Color("TextColor"))
			}
			
			ToolbarItem(placement: .navigationBarTrailing) {
				Button(action: {
					guard let bike = bikeVM.bike else {
						print("Aucun vélo disponible")
						return
					}
					ExportPDFHelper().sharePDF(
						bike: bike,
						from: maintenanceVM.maintenances
					)
				}) {
					Image(systemName: "square.and.arrow.up")
						.imageScale(.large)
						.foregroundColor(Color("TextColor"))
				}
			}
		}
		.navigationBarTitleDisplayMode(.inline)
		.alert(
			isPresented: Binding(
				get: { bikeVM.showAlert || maintenanceVM.showAlert || VM.showAlert },
				set: { newValue in
					if !newValue {
						bikeVM.showAlert = false
						maintenanceVM.showAlert = false
						VM.showAlert = false
					}
				}
			)
		) {
			if bikeVM.showAlert {
				return Alert(
					title: Text(NSLocalizedString("bike_error", comment: "")),
					message: Text(bikeVM.error?.localizedDescription ?? NSLocalizedString("unknown_error", comment: "")),
					dismissButton: .default(Text("OK")) {
						bikeVM.showAlert = false
						bikeVM.error = nil
					}
				)
			} else if maintenanceVM.showAlert {
				return Alert(
					title: Text(NSLocalizedString("maintenance_error", comment: "")),
					message: Text(maintenanceVM.error?.localizedDescription ?? NSLocalizedString("unknown_error", comment: "")),
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


/*#Preview {
    DashboardView()
}
*/
