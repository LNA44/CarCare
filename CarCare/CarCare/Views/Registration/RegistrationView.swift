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
						Picker("Marque", selection: $bikeVM.brand) {
							ForEach(Brand.allCases) { brand in
								Text(brand.rawValue).tag(brand)
							}
						}
						.pickerStyle(MenuPickerStyle()) // Menu déroulant
					}
					
					VStack {
						Text("Modèle")
						Picker("Modèle", selection: $bikeVM.model) {
							ForEach(bikeVM.models, id: \.self) { model in
								Text(model).tag(model)
							}
						}
						.pickerStyle(MenuPickerStyle())
					}
					
					VStack (spacing: 50){
						VStack {
							Text("Année")
							TextField("Année", text: Binding(
								get: { String(bikeVM.year) }, // get convertit l’Int en String pour l’affichage
								set: { bikeVM.year = Int($0) ?? bikeVM.year } //set convertit le String saisi en Int, en laissant l’ancienne valeur si conversion impossible.
							))
							.keyboardType(.numberPad)
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
					let success = bikeVM.addBike()
					if success {
						shouldNavigate = true
					}
					appState.status = .ready
				}) {
					Text("Ajouter le vélo")
						.foregroundColor(.white)
				}
				.frame(width: 180)
				.padding()
				.background(Color .red)
				.cornerRadius(10)
			}
			.navigationDestination(isPresented: $shouldNavigate) {
			}
		}
	}
}

#Preview {
    RegistrationView()
}
