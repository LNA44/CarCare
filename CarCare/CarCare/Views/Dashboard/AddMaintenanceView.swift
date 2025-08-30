//
//  AddMaintenanceView.swift
//  CarCare
//
//  Created by Ordinateur elena on 16/08/2025.
//

import SwiftUI

struct AddMaintenanceView: View {
	@ObservedObject var maintenanceVM: MaintenanceVM
	@StateObject private var VM: AddMaintenanceVM
	@State var showingDatePicker: Bool = false
	@Environment(\.dismiss) var dismiss
	var onAdd: () -> Void
	
	let formatter: DateFormatter = {
		let df = DateFormatter()
		df.dateStyle = .medium   // format type "27 août 2025"
		df.timeStyle = .none     // on n'affiche pas l'heure
		df.locale = Locale(identifier: "fr_FR") // pour le français
		return df
	}()
	
	init(maintenanceVM: MaintenanceVM, onAdd: @escaping () -> Void) {
		self.maintenanceVM = maintenanceVM
		self.onAdd = onAdd
		_VM = StateObject(wrappedValue: AddMaintenanceVM(maintenanceVM: maintenanceVM))
	}
	
	var body: some View {
		VStack {
			VStack(spacing: 20) {
				VStack {
					Text("Type d'entretien")
						.font(.custom("SpaceGrotesk-Bold", size: 16))
						.frame(maxWidth: .infinity, alignment: .leading)
					
					Picker("Type", selection: $VM.selectedMaintenanceType) {
						ForEach(MaintenanceType.allCases) { maintenanceType in
							Text(maintenanceType.rawValue).tag(maintenanceType)
						}
					}
					.tint(.brown)
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
					
					Button(action: { showingDatePicker = true }) {
						HStack {
							Text(formatter.string(from: VM.selectedMaintenanceDate ?? Date()))
								.foregroundColor(.brown)
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
			
			PrimaryButton(title: "Ajouter l'entretien", font: .custom("SpaceGrotesk-Bold", size: 16), foregroundColor: .white, backgroundColor: Color("AppPrimaryColor")) {
				VM.addMaintenance()
				onAdd() //pour recharger la dernière maintenance dans Dashboard
				dismiss()
			}
		}
		.toolbar {
			ToolbarItem(placement: .principal) {
				Text("Ajouter un entretien")
					.font(.custom("SpaceGrotesk-Bold", size: 22))
					.foregroundColor(.black)
			}
		}
		.sheet(isPresented: $showingDatePicker) {
			DatePicker(
				"Sélectionnez la date",
				selection: Binding(
					get: { VM.selectedMaintenanceDate ?? Date() },   // valeur par défaut si nil
					set: { VM.selectedMaintenanceDate = $0 }
				),
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
