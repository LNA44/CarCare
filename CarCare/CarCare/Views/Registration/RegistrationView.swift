//
//  RegistrationView.swift
//  CarCare
//
//  Created by Ordinateur elena on 22/07/2025.
//

import SwiftUI

struct RegistrationView: View {
	@EnvironmentObject var bikeVM: BikeVM
	@EnvironmentObject var appState: AppState
	@State private var shouldNavigate = false
	
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
							
							Picker("Marque", selection: $bikeVM.brand) {
								ForEach(Brand.allCases) { brand in
									Text(brand.rawValue).tag(brand)
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
							
							Picker("Modèle", selection: $bikeVM.model) {
								ForEach(bikeVM.models, id: \.self) { model in
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
							Text("Année de fabrication")
								.frame(maxWidth: .infinity, alignment: .leading)
							
							/*TextField("Année", text: Binding(
							 get: { bikeVM.year == 0 ? "" : String(bikeVM.year) },
							 set: { bikeVM.year = Int($0) ?? bikeVM.year } //set convertit le String saisi en Int, en laissant l’ancienne valeur si conversion impossible.
							 ))*/
							CustomTextField(placeholder: "Année", text: Binding(
								get: { bikeVM.year == 0 ? "" : String(bikeVM.year) },
								set: { bikeVM.year = Int($0) ?? bikeVM.year }))
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
							CustomTextField(placeholder: "ID", text: Binding(
								get: { bikeVM.identificationNumber },
								set: { bikeVM.identificationNumber = $0 }))
						}
						.frame(maxWidth: .infinity)
						
					}
					.padding(.top, 40)
				}
				.font(.custom("SpaceGrotesk-Bold", size: 16))
				
				Spacer()
				
				PrimaryButton(title: "Ajouter le vélo", font: .custom("SpaceGrotesk-Bold", size: 16), foregroundColor: .white, backgroundColor: Color("AppPrimaryColor")) {
					let success = bikeVM.addBike()
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

#Preview {
    RegistrationView()
}
