//
//  BikeModificationsView.swift
//  CarCare
//
//  Created by Ordinateur elena on 16/08/2025.
//

import SwiftUI

struct BikeModificationsView: View {
	@ObservedObject var viewModel: DashboardVM
	@Binding var showingSheet: Bool
	@State private var selectedBrand: Brand = .Unknown
	@State private var selectedModel: String = ""
	@State private var yearText: String = ""
	@State private var selectedType: BikeType = .Manual


    var body: some View {
		ScrollView {
			VStack {
				Text("Modifiez les informations de votre vélo")
					.font(.largeTitle)
					.multilineTextAlignment(.center)
			}
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
						// Réinitialise le modèle pour qu'il soit valide
						selectedModel = newBrand.models.first ?? ""
					}
					.pickerStyle(MenuPickerStyle()) // Menu déroulant
				}
				
				VStack {
					Text("Modèle")
					Picker("Modèle", selection: $selectedModel) {
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
							.background(Color .gray)
							.cornerRadius(10)
					}
				}
				.padding(.horizontal, 70)
			}
			.padding(.vertical, 50)
			.bold()
			
			Button(action: {
				viewModel.modifyBikeInformations(brand: selectedBrand, model: selectedModel, year: Int(yearText) ?? 0, type: selectedType)
				showingSheet = false
				viewModel.fetchBikeData()
			}) {
				Text("Modifier les informations")
					.foregroundColor(.white)
			}
			.frame(width: 180)
			.padding()
			.background(Color .red)
			.cornerRadius(10)
			.onAppear {
				if let bike = viewModel.bike {// récupéré via ton VM
					let validModel = bike.brand.models.contains(bike.model) ? bike.model : bike.brand.models.first ?? ""
					selectedBrand = bike.brand
					selectedModel = validModel
					selectedType = bike.bikeType
					yearText = String(bike.year)
				}
			}
		}
	}
}

/*#Preview {
	BikeModificationsView(viewModel: viewModel, showingSheet: <#T##Binding<Bool>#>)
}
*/
