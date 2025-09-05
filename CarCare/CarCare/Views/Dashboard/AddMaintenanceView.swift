//
//  AddMaintenanceView.swift
//  CarCare
//
//  Created by Ordinateur elena on 16/08/2025.
//

import SwiftUI

struct AddMaintenanceView: View {
	@Environment(\.dismiss) private var dismiss
	@ObservedObject var bikeVM: BikeVM
	@ObservedObject var maintenanceVM: MaintenanceVM
	@StateObject private var VM: AddMaintenanceVM
	@State var showingDatePicker: Bool = false
	var onAdd: () -> Void
	
	let formatter: DateFormatter = {
		let df = DateFormatter()
		df.dateStyle = .medium   // format type "27 août 2025"
		df.timeStyle = .none     // on n'affiche pas l'heure
		df.locale = Locale.current
		return df
	}()
	
	init(bikeVM: BikeVM, maintenanceVM: MaintenanceVM, onAdd: @escaping () -> Void) {
		self.bikeVM = bikeVM
		self.maintenanceVM = maintenanceVM
		self.onAdd = onAdd
		_VM = StateObject(wrappedValue: AddMaintenanceVM(maintenanceVM: maintenanceVM))
	}
	
	var body: some View {
		VStack {
			VStack(spacing: 20) {
				VStack {
					Text(NSLocalizedString("maintenance_Type_key", comment: ""))
						.font(.system(size: 16, weight: .bold, design: .rounded))
						.foregroundColor(Color("TextColor"))
						.frame(maxWidth: .infinity, alignment: .leading)
					
					Picker("Type", selection: $VM.selectedMaintenanceType) {
						ForEach(VM.filteredMaintenanceTypes(for: bikeVM.bikeType), id: \.self) { maintenanceType in
							Text(maintenanceType.localizedName).tag(maintenanceType)
								.font(.system(size: 16, weight: .regular, design: .rounded))
						}
					}
					.tint(Color("TextColor"))
					.pickerStyle(MenuPickerStyle())
					.frame(maxWidth: .infinity, alignment: .leading)
					.frame(height: 40)
					.background(Color("InputSurfaceColor"))
					.cornerRadius(10)
				}
				
				VStack {
					Text(NSLocalizedString("maintenance_date_key", comment: ""))
						.font(.system(size: 16, weight: .bold, design: .rounded))
						.foregroundColor(Color("TextColor"))
						.frame(maxWidth: .infinity, alignment: .leading)
					
					Button(action: { showingDatePicker = true }) {
						HStack {
							Text(formatter.string(from: VM.selectedMaintenanceDate ?? Date()))
								.foregroundColor(Color("TextColor"))
								.font(.system(size: 16, weight: .regular, design: .rounded))

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
			
			PrimaryButton(title: NSLocalizedString("button_Add_Maintenance", comment: ""), foregroundColor: .white, backgroundColor: Color("AppPrimaryColor")) {
				VM.addMaintenance()
				onAdd() //pour recharger la dernière maintenance dans Dashboard
				dismiss()
			}
		}
		.toolbar {
			ToolbarItem(placement: .principal) {
				Text(NSLocalizedString("navigation_title_add_maintenance_key", comment: ""))
					.font(.system(size: 22, weight: .bold, design: .rounded))
					.foregroundColor(Color("TextColor"))
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
			Button(NSLocalizedString("done_key", comment: "")) {
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
		.navigationBarBackButtonHidden(true)
		.toolbar {
			ToolbarItem(placement: .navigationBarLeading) {
				Button(action: {
					dismiss()
				}) {
					Text(NSLocalizedString("return_key", comment: ""))
						.font(.system(size: 16, weight: .regular, design: .rounded))
						.foregroundColor(Color("TextColor"))
				}
			}
		}
		.alert(isPresented: $bikeVM.showAlert) {
			Alert(
				title: Text(NSLocalizedString("error_title", comment: "Title for error alert")),
				message: Text(bikeVM.error?.localizedDescription ?? NSLocalizedString("unknown_error", comment: "Fallback unknown error")),
				dismissButton: .default(Text("OK")) {
					bikeVM.showAlert = false
					bikeVM.error = nil
				}
			)
		}
	}
}

/*#Preview {
 AddMaintenanceView(viewModel: DashboardVM())
 }
 */
