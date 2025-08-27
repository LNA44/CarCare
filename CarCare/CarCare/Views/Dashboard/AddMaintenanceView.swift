//
//  AddMaintenanceView.swift
//  CarCare
//
//  Created by Ordinateur elena on 16/08/2025.
//

import SwiftUI

struct AddMaintenanceView: View {
	@EnvironmentObject var maintenanceVM: MaintenanceVM
	@Binding var showingSheet: Bool
	@State var showingDatePicker: Bool = false
	
	let formatter: DateFormatter = {
		let df = DateFormatter()
		df.dateStyle = .medium   // format type "27 août 2025"
		df.timeStyle = .none     // on n'affiche pas l'heure
		df.locale = Locale(identifier: "fr_FR") // pour le français
		return df
	}()
	
	var body: some View {
		VStack {
			Text("Ajouter un entretien")
				.font(.custom("SpaceGrotesk-Bold", size: 22))
				.padding(.bottom, 40)
			
			VStack(spacing: 20) {
				VStack {
					Text("Type d'entretien")
						.font(.custom("SpaceGrotesk-Bold", size: 16))
						.frame(maxWidth: .infinity, alignment: .leading)
					
					Picker("Type", selection: $maintenanceVM.selectedMaintenanceType) {
						ForEach(MaintenanceType.allCases) { maintenanceType in
							Text(maintenanceType.rawValue).tag(maintenanceType)
						}
					}
					.pickerStyle(MenuPickerStyle())
					.frame(maxWidth: .infinity, alignment: .leading)
					.frame(height: 40)
					.background(Color("InputSurfaceColor"))
					.cornerRadius(10)
				}
				
				VStack {
					Text("Date de l'entretien")
						.font(.custom("SpaceGrotesk-Bold", size: 16))
						.frame(maxWidth: .infinity, alignment: .leading)
					/*HStack {
					 DatePicker(
					 "",
					 selection: $maintenanceVM.selectedMaintenanceDate,  // binding vers une Date
					 displayedComponents: [.date]         // on peut choisir date, heure ou les deux
					 )
					 .datePickerStyle(.compact)
					 }
					 .frame(maxWidth: .infinity,alignment: .leading)
					 .frame(height: 40)
					 .padding(.horizontal, 10)
					 .background(Color("InputSurfaceColor"))
					 .cornerRadius(10)*/
					Button(action: { showingDatePicker = true }) {
						HStack {
							Text(formatter.string(from: maintenanceVM.selectedMaintenanceDate))
								.foregroundColor(.black)
							Spacer()
							Image(systemName: "calendar")
								.foregroundColor(.gray)
						}
						.padding(.horizontal, 10)
						.frame(height: 40)
						.background(Color("InputSurfaceColor"))
						.cornerRadius(10)
					}
				}
			}
			
			Spacer()
			
			/*Button(action: {
				maintenanceVM.addMaintenance()
				showingSheet = false // ferme la sheet
			}) {
				Text("Ajouter l'entretien")
					.frame(maxWidth: .infinity)
					.padding()
					.font(.custom("SpaceGrotesk-Bold", size: 16))
					.background(Color("PrimaryColor"))
					.foregroundColor(.white)
					.cornerRadius(10)
			}*/
			
			PrimaryButton(title: "Ajouter l'entretien", font: .custom("SpaceGrotesk-Bold", size: 16), foregroundColor: .white, backgroundColor: Color("PrimaryColor")) {
				maintenanceVM.addMaintenance()
				showingSheet = false // ferme la sheet
			}
		}
		.sheet(isPresented: $showingDatePicker) {
			DatePicker(
				"Sélectionnez la date",
				selection: $maintenanceVM.selectedMaintenanceDate,
				displayedComponents: [.date]
			)
			.datePickerStyle(.wheel)
			.labelsHidden()
			.padding()
			Button("Terminé") {
				showingDatePicker = false   // ferme la sheet
			}
			.padding()
		}
		.padding(.horizontal, 10)
		.padding(.top, 20)
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
 AddMaintenanceView(viewModel: DashboardVM())
 }
 */
