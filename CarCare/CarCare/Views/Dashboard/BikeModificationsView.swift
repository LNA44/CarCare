//
//  BikeModificationsView.swift
//  CarCare
//
//  Created by Ordinateur elena on 16/08/2025.
//

import SwiftUI

struct BikeModificationsView: View {
	@EnvironmentObject var bikeVM: BikeVM
	@Binding var showingSheet: Bool
	@State private var selectedBrand: Brand = .Unknown
	@State private var selectedModel: String? = nil //optionnel pour la modif de selectedBrand et selectedModel pas encore redéfini
	@State private var yearText: String = ""
	@State private var selectedType: BikeType = .Manual
	@State private var identificationNumber: String = ""


    var body: some View {
		ScrollView {
			VStack {
				Text("Modifie les informations de ton vélo")
					.font(.largeTitle)
					.multilineTextAlignment(.center)
			}
			.padding(.top, 20)
			.padding(.horizontal, 20)
			
			
			VStack (spacing: 40) {
				VStack {
					Text("Marque")
					Picker("Marque", selection: $selectedBrand) {
						ForEach(Brand.allCases) { brand in
							Text(brand.rawValue).tag(brand)
						}
					}
					.onChange(of: selectedBrand) { newBrand in
						if !newBrand.models.contains(selectedModel ?? "") {
							selectedModel = newBrand.models.first ?? ""
						}
					}
					.pickerStyle(MenuPickerStyle()) // Menu déroulant
				}
				
				VStack {
					Text("Modèle")
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
					.pickerStyle(MenuPickerStyle())
				}
				
				VStack {
					Text("Type")
					Picker("Type", selection: $selectedType) {
						ForEach(BikeType.allCases, id: \.self) { type in
							Text(type.rawValue).tag(type)
						}
					}
				}
				
				VStack (spacing: 50){
					VStack {
						Text("Année")
						TextField("Année", text: $yearText)
							.frame(height: 40)
							.multilineTextAlignment(.center)
							.background(Color .gray.opacity(0.2))
							.cornerRadius(10)
					}
					
					VStack {
						Text("Numéro d'identification")
						TextField("NuméroIdentification", text: $identificationNumber)
							.frame(height: 40)
							.multilineTextAlignment(.center)
							.background(Color .gray.opacity(0.2))
							.cornerRadius(10)
					}
				}
				.padding(.horizontal, 70)
			}
			.padding(.vertical, 50)
			.bold()
			
			Button(action: {
				bikeVM.modifyBikeInformations(brand: selectedBrand, model: selectedModel ?? "", year: Int(yearText) ?? 0, type: selectedType, identificationNumber: identificationNumber)
				showingSheet = false
				bikeVM.fetchBikeData()
			}) {
				Text("Modifier les informations")
					.foregroundColor(.white)
			}
			.frame(width: 240)
			.padding()
			.background(Color .red)
			.cornerRadius(10)
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
		}
	}
}

/*#Preview {
	BikeModificationsView(viewModel: viewModel, showingSheet: <#T##Binding<Bool>#>)
}
*/
