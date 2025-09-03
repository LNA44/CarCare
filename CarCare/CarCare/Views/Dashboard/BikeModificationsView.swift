//
//  BikeModificationsView.swift
//  CarCare
//
//  Created by Ordinateur elena on 16/08/2025.
//

import SwiftUI

struct BikeModificationsView: View {
	@ObservedObject var bikeVM: BikeVM
	@State private var selectedBrand: Brand = .Unknown
	@State private var selectedModel: String = ""
	@State private var yearText: String = ""
	@State private var selectedType: BikeType = .Manual
	@State private var identificationNumber: String = ""
	@Environment(\.dismiss) var dismiss
	
	var body: some View {
		VStack {			
			Image(systemName: "bicycle")
				.resizable()
				.frame(width: 70, height: 40)
				.foregroundColor(Color("TextColor"))
				.padding(.top, 10)
			
			VStack(spacing: 20) {
				VStack {
					Text("Marque")
						.frame(maxWidth: .infinity, alignment: .leading)
						.foregroundColor(Color("TextColor"))
					Picker("Marque", selection: $selectedBrand) {
						ForEach(Brand.allCases) { brand in
							Text(brand.rawValue).tag(brand)
								.font(.system(size: 16, weight: .regular, design: .rounded))
						}
					}
					.onChange(of: selectedBrand) {_, newBrand in
						if !newBrand.models.contains(selectedModel) {
							selectedModel = newBrand.models.first ?? ""
						}
					}
					.tint(Color("TextColor"))
					.pickerStyle(MenuPickerStyle()) // Menu déroulant
					.frame(maxWidth: .infinity, alignment: .leading)
					.frame(height: 40)
					.background(Color("InputSurfaceColor"))
					.cornerRadius(10)
				}
				
				VStack {
					Text("Modèle")
						.frame(maxWidth: .infinity, alignment: .leading)
						.foregroundColor(Color("TextColor"))
					Picker("Modèle", selection: Binding(
						get: {
							selectedBrand.models.contains(selectedModel) ? selectedModel : selectedBrand.models.first ?? ""
						},
						set: { newValue in
							selectedModel = newValue
						}
					)) {
						ForEach(selectedBrand.models, id: \.self) { model in
							Text(model).tag(model)
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
					Text("Type")
						.frame(maxWidth: .infinity, alignment: .leading)
						.foregroundColor(Color("TextColor"))
					
					Picker("Type", selection: $selectedType) {
						ForEach(BikeType.allCases, id: \.self) { type in
							Text(type.rawValue).tag(type)
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
				.frame(maxWidth: .infinity)
				
				VStack {
					Text("Année")
						.frame(maxWidth: .infinity, alignment: .leading)
						.foregroundColor(Color("TextColor"))
					
					CustomTextField(placeholder: "", text: $yearText)
				}
				
				VStack {
					Text("Numéro d'identification")
						.frame(maxWidth: .infinity, alignment: .leading)
						.foregroundColor(Color("TextColor"))
					
					CustomTextField(placeholder: "", text: $identificationNumber)
				}
			}
			.font(.system(size: 16, weight: .bold, design: .rounded))
			
			Spacer()
			
			PrimaryButton(title: "Modifier les informations", foregroundColor: .white, backgroundColor: Color("AppPrimaryColor")) {
				bikeVM.modifyBikeInformations(brand: selectedBrand, model: selectedModel, year: Int(yearText) ?? 0, type: selectedType, identificationNumber: identificationNumber)
				dismiss()
			}
		}
		.onAppear {
			self.selectedBrand = bikeVM.brand
			self.selectedModel = bikeVM.model
			self.selectedType = bikeVM.bikeType
			self.yearText = String(bikeVM.year)
			self.identificationNumber = bikeVM.identificationNumber
		}
		.toolbar {
			ToolbarItem(placement: .principal) {
				Text("Mon vélo")
					.font(.system(size: 22, weight: .bold, design: .rounded))
					.foregroundColor(Color("TextColor"))
			}
		}
		.padding(.horizontal, 10)
		.alert(isPresented: $bikeVM.showAlert) {
			Alert(
				title: Text("Erreur"),
				message: Text(bikeVM.error?.errorDescription ?? "Erreur inconnue"),
				dismissButton: .default(Text("OK")) {
					bikeVM.showAlert = false
					bikeVM.error = nil
				}
			)
		}
	}
}

/*#Preview {
 BikeModificationsView(viewModel: viewModel, showingSheet: <#T##Binding<Bool>#>)
 }
*/
