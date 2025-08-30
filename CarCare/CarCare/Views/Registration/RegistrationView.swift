//
//  RegistrationView.swift
//  CarCare
//
//  Created by Ordinateur elena on 22/07/2025.
//

import SwiftUI

struct RegistrationView: View {
	@ObservedObject var bikeVM: BikeVM
	@EnvironmentObject var appState: AppState
	@State private var shouldNavigate = false
	@State private var selectedBrand: Brand = .Unknown
	@State private var selectedModel: String = ""
	@State private var selectedType: BikeType = .Manual
	@State private var yearText: String = ""
	@State private var identificationNumber: String = ""
	
	var body: some View {
		NavigationStack {
			VStack {
				VStack {
					VStack (spacing: 20) {
						Text("Bienvenue")
							.font(.custom("SpaceGrotesk-Bold", size: 22))
							.frame(maxWidth: .infinity, alignment: .leading)
						
						Text("Entrez les informations de votre vélo")
							.font(.custom("SpaceGrotesk-Regular", size: 16))
							.frame(maxWidth: .infinity, alignment: .leading)
					}
					.padding(.top, 40)
					
					VStack (spacing: 20) {
						VStack {
							Text("Marque")
								.frame(maxWidth: .infinity, alignment: .leading)
							
							Picker("Marque", selection: $selectedBrand) {
								ForEach(Brand.allCases) { brand in
									Text(brand.rawValue).tag(brand)
								}
							}
							.onChange(of: selectedBrand) {_, newBrand in
								if !newBrand.models.contains(selectedModel) {
									selectedModel = newBrand.models.first ?? ""
								}
							}
							.pickerStyle(MenuPickerStyle()) // Menu déroulant
							//.font(.custom("SpaceGrotesk-Regular", size: 16))
							//.foregroundColor(.brown)
							.frame(maxWidth: .infinity, alignment: .leading)
							.frame(height: 40)
							.background(Color("InputSurfaceColor"))
							.cornerRadius(10)
							
						}
						
						VStack {
							Text("Modèle")
								.frame(maxWidth: .infinity, alignment: .leading)
							
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
								}
							}
							.pickerStyle(MenuPickerStyle())
							.frame(maxWidth: .infinity, alignment: .leading)
							.frame(height: 40)
							.background(Color("InputSurfaceColor"))
							.cornerRadius(10)
						}
						
						VStack {
							Text("Type")
								.frame(maxWidth: .infinity, alignment: .leading)
							Picker("Type", selection: $selectedType) {
								ForEach(BikeType.allCases, id: \.self) { type in
									Text(type.rawValue).tag(type)
								}
							}
							.pickerStyle(MenuPickerStyle())
							.frame(maxWidth: .infinity, alignment: .leading)
							.frame(height: 40)
							.background(Color("InputSurfaceColor"))
							.cornerRadius(10)
						}
						.frame(maxWidth: .infinity)
						
						VStack {
							Text("Année de fabrication")
								.frame(maxWidth: .infinity, alignment: .leading)
							
							/*TextField("Année", text: Binding(
							 get: { bikeVM.year == 0 ? "" : String(bikeVM.year) },
							 set: { bikeVM.year = Int($0) ?? bikeVM.year } //set convertit le String saisi en Int, en laissant l’ancienne valeur si conversion impossible.
							 ))*/
							CustomTextField(placeholder: "", text: $yearText)
							.keyboardType(.numberPad)
						}
						.frame(maxWidth: .infinity)
						
						VStack {
							Text("Numéro d'identification (optionnel)")
								.frame(maxWidth: .infinity, alignment: .leading)
							
							/*TextField("ID", text: Binding(
							 get: { bikeVM.identificationNumber },
							 set: { bikeVM.identificationNumber = $0 }
							 ))*/
							CustomTextField(placeholder: "", text: $identificationNumber)
						}
						.frame(maxWidth: .infinity)
						
					}
					.padding(.top, 40)
				}
				.font(.custom("SpaceGrotesk-Bold", size: 16))
				
				Spacer()
				
				PrimaryButton(title: "Ajouter le vélo", font: .custom("SpaceGrotesk-Bold", size: 16), foregroundColor: .white, backgroundColor: Color("AppPrimaryColor")) {
					let success = bikeVM.addBike(brand: selectedBrand, model: selectedModel, year: Int(yearText) ?? 0, type: selectedType, identificationNumber: identificationNumber)
					if success {
						shouldNavigate = true
					}
					appState.status = .ready
				}
			}
			.padding(.horizontal, 10)
			.navigationDestination(isPresented: $shouldNavigate) {
			}
		}
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
    RegistrationView()
}
*/
