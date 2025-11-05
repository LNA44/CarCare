//
//  BikeModificationsView.swift
//  CarCare
//
//  Created by Ordinateur elena on 16/08/2025.
//

import SwiftUI

struct BikeModificationsView: View {
	@EnvironmentObject var appState: AppState
	@Environment(\.dismiss) private var dismiss
	@ObservedObject var bikeVM: BikeVM
	@ObservedObject var notificationVM: NotificationViewModel
	@State private var brandText: String = ""
	@State private var modelText: String = ""
	@State private var yearText: String = ""
	@State private var selectedType: BikeType = .Manual
	@State private var identificationNumber: String = ""
	@State private var showDeleteAlert = false
	var onDelete: (() -> Void)? = nil
    @State private var selectedImage: UIImage? = nil
    let haptic = UIImpactFeedbackGenerator(style: .medium)
	
	var body: some View {
        ScrollView {
            VStack {
                Image(systemName: "bicycle")
                    .resizable()
                    .frame(width: 70, height: 40)
                    .foregroundColor(Color("TextColor"))
                    .padding(.top, 10)
                    .accessibilityHidden(true)
                
                VStack(spacing: 20) {
                    VStack {
                        Text(NSLocalizedString("brand_key", comment: ""))
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .foregroundColor(Color("TextColor"))
                            .accessibilityAddTraits(.isHeader)
                        
                        CustomTextField(placeholder: "", text: $brandText)
                            .accessibilityLabel("Brand")
                            .accessibilityValue(brandText)
                            .accessibilityHint("Enter the brand of your bike")
                    }
                    
                    VStack {
                        Text(NSLocalizedString("model_key", comment: ""))
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .foregroundColor(Color("TextColor"))
                            .accessibilityAddTraits(.isHeader)
                        
                        CustomTextField(placeholder: "", text: $modelText)
                            .accessibilityLabel("Model")
                            .accessibilityValue(modelText)
                            .accessibilityHint("Enter the model of your bike")
                    }
                    
                    VStack {
                        Text(NSLocalizedString("type_key", comment: ""))
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .foregroundColor(Color("TextColor"))
                            .accessibilityAddTraits(.isHeader)
                        
                        Picker("Type", selection: $selectedType) {
                            ForEach(BikeType.allCases, id: \.self) { type in
                                Text(type.localizedName).tag(type)
                                    .font(.system(size: 16, weight: .regular, design: .default))
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
                        .accessibilityHint("Double tap to select your bike type")
                    }
                    .frame(maxWidth: .infinity)
                    
                    VStack {
                        Text(NSLocalizedString("year_of_manufacture_key", comment: ""))
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .foregroundColor(Color("TextColor"))
                            .accessibilityAddTraits(.isHeader)
                        
                        CustomTextField(placeholder: "", text: $yearText)
                            .accessibilityLabel("Year of manufacture")
                            .accessibilityValue(yearText)
                            .accessibilityHint("Enter the year your bike was manufactured")
                    }
                    
                    VStack {
                        Text(NSLocalizedString("identification_number_message_key", comment: ""))
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .foregroundColor(Color("TextColor"))
                            .accessibilityAddTraits(.isHeader)
                        
                        CustomTextField(placeholder: "", text: $identificationNumber)
                            .accessibilityLabel("Identification Number")
                            .accessibilityValue(identificationNumber)
                            .accessibilityHint("Enter the bike’s identification number")
                    }
                    
                    BikePhotoPickerView(selectedImage: $selectedImage)
                        .accessibilityLabel("Bike Photo")
                        .accessibilityHint("Double tap to select a photo for your bike")
                }
                .font(.system(size: 16, weight: .bold, design: .default))
                
                Spacer()
                
                VStack(spacing: 20) {
                    PrimaryButton(title: NSLocalizedString("button_delete_bike", comment: "Titre du bouton pour supprimer le vélo"), foregroundColor: .white, backgroundColor: Color("ToDoColor")) {
                        haptic.impactOccurred()
                        showDeleteAlert = true
                    }
                    .accessibilityLabel("Delete Bike")
                    .accessibilityHint("Double tap to delete this bike")
                    
                    PrimaryButton(title: NSLocalizedString("button_Modify_information_key", comment: ""), foregroundColor: .white, backgroundColor: Color("AppPrimaryColor")) {
                        haptic.impactOccurred()
                        bikeVM.modifyBikeInformations(brand: brandText, model: modelText, year: Int(yearText) ?? 0, type: selectedType, identificationNumber: identificationNumber, image: selectedImage)
                        dismiss()
                    }
                    .accessibilityLabel("Modify Information")
                    .accessibilityHint("Double tap to save changes to this bike")
                }
                .padding(.top, 10)
            }
            .padding(.bottom, 60)
            .onAppear {
                haptic.impactOccurred()
                self.brandText = bikeVM.brand
                self.modelText = bikeVM.model
                self.selectedType = bikeVM.bikeType
                self.yearText = String(bikeVM.year)
                self.identificationNumber = bikeVM.identificationNumber
                if let data = bikeVM.bike?.imageData,
                   let uiImage = UIImage(data: data) {
                    selectedImage = uiImage
                }
            }
            .frame(maxWidth: .infinity)
            .contentShape(Rectangle()) // rend la zone tappable même vide
            .onTapGesture {
                UIApplication.shared.endEditing()
            }
            .navigationBarBackButtonHidden(true)
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Text(NSLocalizedString("navigation_title_modify_bike_key", comment: ""))
                        .font(.system(size: 22, weight: .bold, design: .default))
                        .foregroundColor(Color("TextColor"))
                        .accessibilityAddTraits(.isHeader)
                        .accessibilityLabel("Modify Bike")
                }
                
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: {
                        dismiss()
                    }) {
                        Image(systemName: "chevron.left")
                            .font(.system(size: 16, weight: .regular))
                            .foregroundColor(Color("TextColor"))
                            .accessibilityLabel("Return")
                            .accessibilityHint("Double tap to go back")
                    }
                }
            }
            .padding(.horizontal, 10)
            .alert(
                isPresented: Binding(
                    get: { showDeleteAlert || bikeVM.showAlert },
                    set: { newValue in
                        if !newValue {
                            showDeleteAlert = false
                            bikeVM.showAlert = false
                        }
                    }
                )
            ) {
                if showDeleteAlert {
                    return Alert(
                        title: Text(NSLocalizedString("delete_bike_confirmation_title", comment: "Confirmation message before deleting a bike")),
                        primaryButton: .destructive(Text(NSLocalizedString("delete_bike_confirm", comment: "Delete bike confirmation button"))) {
                            bikeVM.deleteCurrentBike()
                            notificationVM.cancelAllNotifications()
                            onDelete?()
                            withAnimation {
                                appState.status = .needsVehicleRegistration
                            }
                        },
                        secondaryButton: .cancel(Text(NSLocalizedString("delete_bike_cancel", comment: "Cancel delete bike button")))
                    )
                } else {
                    return Alert(
                        title: Text(NSLocalizedString("error_title", comment: "")),
                        message: Text(bikeVM.error?.localizedDescription ?? NSLocalizedString("unknown_error", comment: "")),
                        dismissButton: .default(Text("OK")) {
                            bikeVM.showAlert = false
                            bikeVM.error = nil
                        }
                    )
                }
            }
        }
        .background(
            LinearGradient(
                gradient: Gradient(colors: [Color("BackgroundColor"), Color("BackgroundColor2")]),
                startPoint: .top,
                endPoint: .bottom
            )
        )
	}
}

/*#Preview {
 BikeModificationsView(viewModel: viewModel, showingSheet: <#T##Binding<Bool>#>)
 }
*/
