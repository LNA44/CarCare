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

	
	var body: some View {
        ScrollView {
            VStack {
                Image(systemName: "bicycle")
                    .resizable()
                    .frame(width: 70, height: 40)
                    .foregroundColor(Color("TextColor"))
                    .padding(.top, 10)
                
                VStack(spacing: 20) {
                    VStack {
                        Text(NSLocalizedString("brand_key", comment: ""))
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .foregroundColor(Color("TextColor"))
                        
                        CustomTextField(placeholder: "", text: $brandText)
                    }
                    
                    VStack {
                        Text(NSLocalizedString("model_key", comment: ""))
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .foregroundColor(Color("TextColor"))
                        
                        CustomTextField(placeholder: "", text: $modelText)
                    }
                    
                    VStack {
                        Text(NSLocalizedString("type_key", comment: ""))
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .foregroundColor(Color("TextColor"))
                        
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
                            .foregroundColor(Color("TextColor"))
                        
                        CustomTextField(placeholder: "", text: $yearText)
                    }
                    
                    VStack {
                        Text(NSLocalizedString("identification_number_message_key", comment: ""))
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .foregroundColor(Color("TextColor"))
                        
                        CustomTextField(placeholder: "", text: $identificationNumber)
                    }
                    
                    BikePhotoPickerView(selectedImage: $selectedImage)
                }
                .font(.system(size: 16, weight: .bold, design: .rounded))
                
                Spacer()
                
                VStack(spacing: 20) {
                    PrimaryButton(title: NSLocalizedString("button_delete_bike", comment: "Titre du bouton pour supprimer le vélo"), foregroundColor: .white, backgroundColor: Color("ToDoColor")) {
                        showDeleteAlert = true
                    }
                    
                    PrimaryButton(title: NSLocalizedString("button_Modify_information_key", comment: ""), foregroundColor: .white, backgroundColor: Color("AppPrimaryColor")) {
                        bikeVM.modifyBikeInformations(brand: brandText, model: modelText, year: Int(yearText) ?? 0, type: selectedType, identificationNumber: identificationNumber, image: selectedImage)
                        dismiss()
                    }
                }
                .padding(.top, 10)
            }
            .onAppear {
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
                        .font(.system(size: 22, weight: .bold, design: .rounded))
                        .foregroundColor(Color("TextColor"))
                }
                
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: {
                        dismiss()
                    }) {
                        Text(NSLocalizedString("return_key", comment: ""))
                            .font(.system(size: 16, weight: .regular, design: .rounded))
                            .foregroundColor(Color("TextColor"))
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
