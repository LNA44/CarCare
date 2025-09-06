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
						Text(NSLocalizedString("welcome_key", comment: ""))
							.font(.system(size: 22, weight: .bold, design: .rounded))
							.frame(maxWidth: .infinity, alignment: .leading)
						
						Text(NSLocalizedString("bike_info_key", comment: ""))
							.frame(maxWidth: .infinity, alignment: .leading)
					}
					.padding(.top, 40)
					
					VStack (spacing: 20) {
						VStack {
							Text(NSLocalizedString("brand_key", comment: ""))
								.frame(maxWidth: .infinity, alignment: .leading)
							
							Picker("Marque", selection: $selectedBrand) {
								ForEach(Brand.allCases) { brand in
									Text(brand.localizedName).tag(brand)
										.font(.system(size: 16, weight: .regular, design: .rounded))
								}
							}
							.tint(Color("TextColor"))
							.onChange(of: selectedBrand) {_, newBrand in
								if !newBrand.models.contains(selectedModel) {
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
							Text(NSLocalizedString("model_key", comment: ""))
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
							Text(NSLocalizedString("type_key", comment: ""))
								.foregroundColor(Color("TextColor"))
								.frame(maxWidth: .infinity, alignment: .leading)
							Picker("Type", selection: $selectedType) {
								ForEach(BikeType.allCases, id: \.self) { type in
									Text(type.localizedName).tag(type)
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
							Text(NSLocalizedString("year_of_manufacture_key", comment: ""))
								.frame(maxWidth: .infinity, alignment: .leading)
							
							CustomTextField(placeholder: "", text: $yearText)
							.keyboardType(.numberPad)
						}
						.frame(maxWidth: .infinity)
						
						VStack {
							Text(NSLocalizedString("identification_number_message_key", comment: ""))
								.frame(maxWidth: .infinity, alignment: .leading)
							
							CustomTextField(placeholder: "", text: $identificationNumber)
						}
						.frame(maxWidth: .infinity)
						
					}
					.padding(.top, 40)
				}
				.font(.system(size: 16, weight: .bold, design: .rounded))
				.foregroundColor(Color("TextColor"))
				
				Spacer()
				
				PrimaryButton(title: NSLocalizedString("button_add_bike_key", comment: ""), foregroundColor: .white, backgroundColor: Color("AppPrimaryColor")) {
					let success = bikeVM.addBike(brand: selectedBrand, model: selectedModel, year: Int(yearText) ?? 0, type: selectedType, identificationNumber: identificationNumber)
					print("Type de vélo: \(selectedType)")
					if success {
						shouldNavigate = true
						appState.status = .ready
					}
				}
			}
			.padding(.horizontal, 10)
			.navigationDestination(isPresented: $shouldNavigate) {
			}
			.frame(maxWidth: .infinity)
			.contentShape(Rectangle()) // rend la zone tappable même vide
			.onTapGesture {
				UIApplication.shared.endEditing()
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

extension UIApplication {
	func endEditing() {
		sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
	}
}

/*#Preview {
    RegistrationView()
}
*/
