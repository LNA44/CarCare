//
//  BikeModificationsView.swift
//  CarCare
//
//  Created by Ordinateur elena on 16/08/2025.
//

import SwiftUI

struct BikeModificationsView: View {
	@EnvironmentObject var bikeVM: BikeVM
	@State private var selectedBrand: Brand = .Unknown
	@State private var selectedModel: String? = nil //optionnel pour la modif de selectedBrand et selectedModel pas encore redéfini
	@State private var yearText: String = ""
	@State private var selectedType: BikeType = .Manual
	@State private var identificationNumber: String = ""
	@State private var goToDashboard = false
	
	var body: some View {
		VStack {			
			Image("Bicycle")
				.resizable()
				.frame(width: 70, height: 70)
			
			VStack(spacing: 20) {
				VStack {
					Text("Marque")
						.frame(maxWidth: .infinity, alignment: .leading)
					Picker("Marque", selection: $selectedBrand) {
						ForEach(Brand.allCases) { brand in
							Text(brand.rawValue).tag(brand)
						}
					}
					.onChange(of: selectedBrand) {_, newBrand in
						if !newBrand.models.contains(selectedModel ?? "") {
							selectedModel = newBrand.models.first ?? ""
						}
					}
					.pickerStyle(MenuPickerStyle()) // Menu déroulant
					.frame(maxWidth: .infinity, alignment: .leading)
					.frame(height: 40)
					.background(Color("InputSurfaceColor"))
					.cornerRadius(10)
				}
				
				VStack {
					Text("Modèle")
						.frame(maxWidth: .infinity, alignment: .leading)
					Picker("Modèle", selection: Binding(
						get: { //quand picker affiché
							// Si selectedModel n'est pas dans la liste, on prend le premier modèle
							if let selectedModel = selectedModel, selectedBrand.models.contains(selectedModel) {
								return selectedModel
							} else {
								return selectedBrand.models.first ?? ""
							}
						},
						set: { selectedModel = $0 //quand utilisateur change sélection dans picker : assigne cette valeur à selectedModel
						}
					)) {
						ForEach(selectedBrand.models, id: \.self) { model in
							Text(model).tag(model)
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
					Text("Année")
						.frame(maxWidth: .infinity, alignment: .leading)
					CustomTextField(placeholder: "", text: $yearText)
				}
				
				VStack {
					Text("Numéro d'identification")
						.frame(maxWidth: .infinity, alignment: .leading)
					CustomTextField(placeholder: "", text: $identificationNumber)
				}
			}
			.font(.custom("SpaceGrotesk-Bold", size: 16))
			.bold()
			
			Spacer()
			
			PrimaryButton(title: "Modifier les informations", font: .custom("SpaceGrotesk-Bold", size: 16), foregroundColor: .white, backgroundColor: Color("AppPrimaryColor")) {
				bikeVM.modifyBikeInformations(brand: selectedBrand, model: selectedModel ?? "", year: Int(yearText) ?? 0, type: selectedType, identificationNumber: identificationNumber)
				goToDashboard = true
			}
			// NavigationLink invisible mais déclenché par le Bool
			NavigationLink(
				destination: DashboardView(),
				isActive: $goToDashboard
			) {
				EmptyView()
			}
			
		}
		.onAppear {
			if let bike = bikeVM.bike {
				selectedBrand = bike.brand
				selectedType = bike.bikeType
				yearText = String(bike.year)
				// Vérifie que le modèle enregistré existe bien dans la liste des modèles de la marque
				if bike.brand.models.contains(bike.model) {
					selectedModel = bike.model
				} else {
					// Sinon on prend le premier modèle disponible
					selectedModel = bike.brand.models.first ?? ""
				}
			}
		}
		.toolbar {
			ToolbarItem(placement: .principal) {
				Text("Mon vélo")
					.font(.custom("SpaceGrotesk-Bold", size: 22))
					.foregroundColor(.black) 
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
