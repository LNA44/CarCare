//
//  RegistrationView.swift
//  CarCare
//
//  Created by Ordinateur elena on 22/07/2025.
//

import SwiftUI

struct RegistrationView: View {
	@StateObject var viewModel = RegistrationVM()
	@EnvironmentObject var appState: AppState
	
    var body: some View {
		NavigationStack {
			ScrollView {
				Image(systemName: "car.fill")
					.resizable()
					.scaledToFit()
					.frame(width: 80, height: 80)
					.foregroundColor(.blue)
					.padding(.top, 40)
				
				VStack (spacing: 40){
					Text("Bienvenue")
						.font(.largeTitle)
						.bold()
					
					Text("Entrez les informations de votre vélo")
						.font(.largeTitle)
						.multilineTextAlignment(.center)
				}
				.padding(.horizontal, 20)
				
				
				VStack (spacing: 40) {
					
					VStack {
						Text("Marque")
						Picker("Marque", selection: $viewModel.brand) {
							ForEach(Brand.allCases) { brand in
								Text(brand.rawValue).tag(brand)
							}
						}
						.pickerStyle(MenuPickerStyle()) // Menu déroulant
					}
					
					VStack {
						Text("Modèle")
						Picker("Modèle", selection: $viewModel.model) {
							ForEach(viewModel.models, id: \.self) { model in
								Text(model).tag(model)
							}
						}
						.pickerStyle(MenuPickerStyle())
					}
					
					VStack (spacing: 50){
						VStack {
							Text("Année")
							TextField("Année", text: $viewModel.year)
								.frame(height: 40)
								.multilineTextAlignment(.center)
								.background(Color .gray)
								.cornerRadius(10)
						}
						
						VStack {
							Text("Kilométrage")
							TextField("Kilométrage", text: $viewModel.mileage)
								.frame(height: 40)
								.multilineTextAlignment(.center)
								.background(Color .gray)
								.cornerRadius(10)
						}
					}
					.padding(.horizontal, 70)
					
					/*VStack {
						Text("Carburant")
						Picker("Carburant", selection: $viewModel.fuel) {
							ForEach(Fuel.allCases) { fuel in
								Text(fuel.rawValue).tag(fuel)
							}
						}
						.pickerStyle(MenuPickerStyle())
					}*/
					
				}
				.padding(.vertical, 50)
				.bold()
				
				Button(action: {
					viewModel.addVehicle()
					appState.status = .ready
				}) {
					Text("Ajouter le véhicule")
						.foregroundColor(.white)
				}
				
				.frame(width: 180)
				.padding()
				.background(Color .red)
				.cornerRadius(10)
			}
			.navigationDestination(isPresented: $viewModel.shouldNavigate) {
				
			}
		}
	}
}

#Preview {
    RegistrationView()
}
