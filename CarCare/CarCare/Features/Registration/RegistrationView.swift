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
    @State private var brandText: String = ""
    @State private var modelText: String = ""
	@State private var selectedType: BikeType = .Manual
	@State private var yearText: String = ""
	@State private var identificationNumber: String = ""
    @State private var selectedImage: UIImage? = nil
    @State private var appear = false
    let haptic = UIImpactFeedbackGenerator(style: .medium)
	
	var body: some View {
		NavigationStack {
            ScrollView {
                VStack {
                    VStack {
                        VStack (spacing: 20) {
                            Text(NSLocalizedString("welcome_key", comment: ""))
                                .font(.system(size: 22, weight: .bold, design: .rounded))
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .accessibilityAddTraits(.isHeader)
                                .accessibilityLabel(NSLocalizedString("welcome_key", comment: "Welcome message for registration"))
                            
                            Text(NSLocalizedString("bike_info_key", comment: ""))
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .accessibilityLabel(NSLocalizedString("bike_info_key", comment: "Prompt for entering bike information"))
                        }
                        .padding(.top, 40)
                        
                        VStack (spacing: 20) {
                            VStack {
                                Text(NSLocalizedString("brand_key", comment: ""))
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                
                                CustomTextField(placeholder: "", text: $brandText)
                                    .accessibilityLabel("Brand")
                                    .accessibilityHint("Enter the brand of your bike")
                            }
                            
                            VStack {
                                Text(NSLocalizedString("model_key", comment: ""))
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                
                                CustomTextField(placeholder: "", text: $modelText)
                                    .accessibilityLabel("Model")
                                    .accessibilityHint("Enter the model of your bike")
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
                                .accessibilityLabel("Bike Type")
                                .accessibilityValue(selectedType.localizedName)
                                .accessibilityHint("Select the type of your bike")
                            }
                            .frame(maxWidth: .infinity)
                            
                            VStack {
                                Text(NSLocalizedString("year_of_manufacture_key", comment: ""))
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                
                                CustomTextField(placeholder: "", text: $yearText)
                                    .keyboardType(.numberPad)
                                    .accessibilityLabel("Year of manufacture")
                                    .accessibilityHint("Enter the year your bike was manufactured")
                            }
                            
                            VStack {
                                Text(NSLocalizedString("identification_number_message_key", comment: ""))
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                
                                CustomTextField(placeholder: "", text: $identificationNumber)
                                    .accessibilityLabel("Identification Number")
                                    .accessibilityHint("Enter your bike's identification number")
                            }
                            
                        }
                        .padding(.top, 40)
                    }
                    .font(.system(size: 16, weight: .bold, design: .rounded))
                    .foregroundColor(Color("TextColor"))
                    
                    BikePhotoPickerView(selectedImage: $selectedImage)
                        .padding(.top, 20)
                        .accessibilityLabel("Bike Photo")
                        .accessibilityHint("Tap to choose or take a photo of your bike")
                    
                    Spacer()
                    
                    PrimaryButton(title: NSLocalizedString("button_add_bike_key", comment: ""), foregroundColor: .white, backgroundColor: Color("AppPrimaryColor")) {
                        haptic.impactOccurred()
                        let success = bikeVM.addBike(brand: brandText, model: modelText, year: Int(yearText) ?? 0, type: selectedType, identificationNumber: identificationNumber, image: selectedImage)
                        if success && brandText != "" && modelText != "" && yearText != "" {
                            shouldNavigate = true
                            appState.status = .ready
                        }
                    }
                    .padding(.top, 20)
                    .accessibilityLabel(NSLocalizedString("button_add_bike_key", comment: "Add bike button"))
                    .accessibilityHint("Double tap to save your bike information and continue")
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
            .opacity(appear ? 1 : 0)
            .scaleEffect(appear ? 1 : 0.95)
            .onAppear {
                withAnimation(.easeOut(duration: 0.5)) {
                    appear = true
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

extension UIApplication {
	func endEditing() {
		sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
	}
}
