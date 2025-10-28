//
//  DashboardView.swift
//  CarCare
//
//  Created by Ordinateur elena on 22/07/2025.
//

import SwiftUI

struct DashboardView: View {
	@AppStorage("isDarkMode") private var isDarkMode = false
	@AppStorage("isPremiumUser") private var isPremiumUser = false
	@ObservedObject var bikeVM: BikeVM
	@ObservedObject var maintenanceVM: MaintenanceVM
	@ObservedObject var notificationVM: NotificationViewModel
	@StateObject private var VM: DashboardVM
	@State private var goToAdd = false
	@State private var didLoadData = false
	@State private var showPaywall = false
    @State private var showPopover = false
	
	let formatter: DateFormatter = {
		let df = DateFormatter()
		df.dateStyle = .medium
		df.timeStyle = .none
		df.locale = Locale.current
		return df
	}()
	
	init(bikeVM: BikeVM, maintenanceVM: MaintenanceVM, notificationVM: NotificationViewModel) {
		self.bikeVM = bikeVM
		self.maintenanceVM = maintenanceVM
		self.notificationVM = notificationVM
		_VM = StateObject(wrappedValue: DashboardVM(maintenanceVM: maintenanceVM))
	}
	
	var body: some View {
		ScrollView {
			VStack(spacing: 10) {
                ZStack {
                    // Fond flou
                    RoundedRectangle(cornerRadius: 20)
                        .fill(.ultraThinMaterial) // ← effet verre
                        .frame(height: 200)
                        .shadow(color: .black.opacity(isDarkMode ? 0.1 : 0.25), radius: 8, x: 0, y: 4)

                    // Optionnel : un gradient ou couleur semi-transparente par-dessus
                    RoundedRectangle(cornerRadius: 20)
                        .fill(
                            LinearGradient(
                                colors: [Color("MainComponentColor").opacity(0.3), Color("MainComponentColor2").opacity(0.3)],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .frame(height: 200)
					
					VStack {
						VStack {
							Text("\(bikeVM.brand.uppercased()) - \(bikeVM.model)")
								.font(.system(size: 24, weight: .bold, design: .rounded))
								.padding(.top, 40)
								.padding(.horizontal, 15)
								.multilineTextAlignment(.center)
								.shadow(color: .black.opacity(0.25), radius: 2, x: 0, y: 2)
								.padding(.bottom, 15)
							
                            HStack(spacing: 30) {
                                VStack(alignment: .leading, spacing: 5) {
                                    Text(String(format: NSLocalizedString("bike_year_label", comment: "")))
                                        .foregroundColor(Color("TextColor"))
                                        .font(.system(size: 16, weight: .medium, design: .rounded))
                                    HStack {
                                        Image(systemName: "calendar")
                                        Text("\(bikeVM.year)")
                                            .font(.system(size: 14, weight: .medium, design: .rounded))
                                    }
                                }
                                
                                Rectangle()
                                    .fill(Color("TextColor"))
                                    .frame(width: 1)
                                    .padding(.vertical, 0)
                                
                                VStack(alignment: .leading, spacing: 5) {
                                    Text(String(
                                        format: NSLocalizedString("identification_number_key", comment: "Label pour le numéro d'identification du vélo")
                                    ))
                                    .foregroundColor(Color("TextColor"))
                                    .font(.system(size: 16, weight: .medium, design: .rounded))
                                    HStack {
                                        Image(systemName:"barcode")
                                        Text("\(bikeVM.identificationNumber)")
                                            .font(.system(size: 14, weight: .medium, design: .rounded))
                                    }
                                }
                            }
						}
						.padding(.top, 50)
					}
					.padding(.bottom, 20)
					.foregroundColor(Color(.brown))
					
					ZStack {
						Circle()
							.fill(Color.white.opacity(0.2))
							.frame(width: 110, height: 110)
                            .offset(y: -80)
                        if let imageData = bikeVM.bike?.imageData,
                           let uiImage = UIImage(data: imageData) {
                            Image(uiImage: uiImage)
                                .resizable()
                                .frame(width: 100, height: 100)
                                .clipShape(Circle())
                                .offset(y: -80)
                                .shadow(color: .black.opacity(0.25), radius: 5, x: 0, y: 2)
                        } else if bikeVM.bike == nil {
                                EmptyView()
                        } else {
                            Image("Riding") 
                                .resizable()
                                .frame(width: 100, height: 100)
                                .clipShape(Circle())
                                .offset(y: -80)
                                .shadow(color: .black.opacity(0.25), radius: 5, x: 0, y: 2)
                        }
                    }
                }
				.padding(.top, 20)
				.padding(.horizontal, 15)
				
				
				Divider()
					.frame(width: 150)
					.padding(.top, 20)
					.padding(.bottom, 10)
				
				VStack {
					VStack(alignment: .center, spacing: 20) {
						Text(NSLocalizedString("maintenance_key", comment: ""))
							.font(.system(size: 27, weight: .bold, design: .rounded))
                            .foregroundColor(Color("TextColor"))
                        
                        Text("\(maintenanceVM.overallStatus.label)")
                            .font(.system(size: 22, weight: .bold, design: .rounded))
                            .foregroundColor(maintenanceVM.overallStatus == .aJour ? Color("DoneColor") :
                                                maintenanceVM.overallStatus == .bientotAPrevoir ? Color("InProgressColor") :
                                                Color("ToDoColor"))
                            .padding(.vertical, 10)
                            .padding(.horizontal, 20)
                            .background(
                                Capsule()
                                    .strokeBorder(
                                        maintenanceVM.overallStatus == .aJour ? Color("DoneColor") :
                                            maintenanceVM.overallStatus == .bientotAPrevoir ? Color("InProgressColor") :
                                            Color("ToDoColor"),
                                        lineWidth: 2
                                    )
                                    .shadow(color: .black.opacity(0.3), radius: 2, x: 0, y: 1)
                            )
                        
                    }
                    .padding(.horizontal, 20)
                }
                .frame(maxWidth: .infinity, alignment: .center)
				.frame(height: 100)
				.cornerRadius(10)
				.padding(.horizontal, 10)
				.padding(.bottom, 20)
				
				ZStack {
					Image("Maintenance")
						.resizable()
						.frame(width: 360, height: 250)
						.cornerRadius(10)
						.scaledToFit()
                        .shadow(color: .black.opacity(isDarkMode ? 0.1 : 0.25), radius: 8, x: 0, y: 4)
                    
                    LinearGradient(
                        colors: [
                            Color.black.opacity(0),
                            Color.black.opacity(0.8)
                        ],
                        startPoint: .top,
                        endPoint: .bottom
                    )
                    .frame(width: 360, height: 250)
                    .cornerRadius(10)
                    
                    
					VStack(alignment: .leading) {
						Text(NSLocalizedString("last_maintenance_key", comment: ""))
							.font(.system(size: 22, weight: .bold, design: .rounded))
							.padding(.bottom, 5)
						
						Text("\(maintenanceVM.generalLastMaintenance?.maintenanceType.localizedName ?? "")")
							.font(.system(size: 16, weight: .bold, design: .rounded))
						
						if let date = maintenanceVM.generalLastMaintenance?.date {
							Text(formatter.string(from: date))
								.font(.system(size: 16, weight: .bold, design: .rounded))
						} else {
							Text(NSLocalizedString("no_date_key", comment: ""))
								.font(.system(size: 16, weight: .bold, design: .rounded))
						}
					}
					.foregroundColor(.white)
					.bold()
					.padding(.horizontal, 10)
					.padding(.vertical, 10)
					.frame(width: 350, height: 250, alignment: .bottomLeading)
					
				}
				.padding(.horizontal, 10)
				.padding(.vertical, 10)
				
				VStack(spacing: 20) {
					NavigationLink(
						destination: BikeModificationsView(bikeVM: bikeVM, notificationVM: notificationVM) {
							//closure de BikeModificationsView
							maintenanceVM.deleteAllMaintenances()
						}
					) {
						Text(NSLocalizedString("button_modify_bike_information", comment: ""))
							.font(.system(size: 16, weight: .bold, design: .rounded))
							.foregroundColor(Color("TextColor"))
							.frame(maxWidth: .infinity)
							.padding()
							.background(Color("BackgroundColor"))
							.cornerRadius(10)
							.overlay(
								Group {
									if isDarkMode {
										RoundedRectangle(cornerRadius: 10)
											.stroke(Color.white.opacity(0.4), lineWidth: 1.5)
									}
								}
							)
					}
					.buttonStyle(.plain)
					.padding(.horizontal, 10)
					.shadow(color: .black.opacity(0.25), radius: 5, x: 0, y: 2)
                    
                    Button {
                        goToAdd = true
                    } label: {
                        Text(NSLocalizedString("button_Add_Maintenance", comment: ""))
                            .font(.system(size: 16, weight: .bold, design: .rounded))
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color("AppPrimaryColor"))
                            .cornerRadius(10)
                    }
                    .padding(.bottom, 20)
                    .padding(.horizontal, 10)
                    .shadow(color: .black.opacity(0.25), radius: 5, x: 0, y: 2)
                }
                .navigationDestination(isPresented: $goToAdd) {
                    AddMaintenanceView(
                        bikeVM: bikeVM,
                        maintenanceVM: maintenanceVM,
                        onAdd: {
                            VM.fetchLastMaintenance(for: bikeVM.bikeType)
                            maintenanceVM.fetchAllMaintenance(for: bikeVM.bikeType)
                        },
                        notificationVM: notificationVM
                    )
                }
                .padding(.top, 10)
            }
            .padding(.top, 20)
            .cornerRadius(15)
            .navigationBarBackButtonHidden(true)
            .onAppear {
                guard !didLoadData else { return } //evite boucle lors du changement de light dark mode
                didLoadData = true
                bikeVM.fetchBikeData() { //bikeData mises dans publised
                    VM.fetchLastMaintenance(for: bikeVM.bikeType)
                    maintenanceVM.fetchAllMaintenance(for: bikeVM.bikeType) //utile pour statut général entretien
                }
            }
            .onChange(of: bikeVM.bikeType) { _, newValue in
                VM.fetchLastMaintenance(for: newValue)
                maintenanceVM.fetchAllMaintenance(for: newValue)
            }
            .onChange(of: maintenanceVM.maintenances) {_, _ in
                VM.fetchLastMaintenance(for: bikeVM.bikeType)
            }
        }
        .background(
            LinearGradient(
                gradient: Gradient(colors: [Color("BackgroundColor"), Color("BackgroundColor2")]),
                startPoint: .top,
                endPoint: .bottom
            )
        )
        .toolbar {
            ToolbarItem(placement: .principal) {
                Text(NSLocalizedString("navigation_title_modify_bike_key", comment: ""))
                    .font(.system(size: 22, weight: .bold, design: .rounded))
                    .foregroundColor(Color("TextColor"))
            }
            
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(action: {
                    if isPremiumUser {
                        guard let bike = bikeVM.bike else {
                            print("Aucun vélo disponible")
                            return
                        }
                        ExportPDFHelper().sharePDF(
                            bike: bike,
                            from: maintenanceVM.maintenances
                        )
                    } else {
                        //showPaywall = true
                        showPopover = true
                    }
                }) {
                    Image(systemName: "square.and.arrow.up")
                        .imageScale(.large)
                        .foregroundColor(Color("TextColor"))
                        .offset(y: -2)
                }
                .popover(isPresented: $showPopover, arrowEdge: .top) {
                    VStack(spacing: 20) {
                        Text(NSLocalizedString("premium_feature", comment: ""))
                            .font(.system(size: 22, weight: .bold, design: .rounded))
                        
                        Text(NSLocalizedString("share_summary_description", comment: ""))
                            .multilineTextAlignment(.center)
                            .font(.system(size: 18, weight: .regular, design: .rounded))
                            .frame(maxWidth: 250)
                        
                        Button(action: {
                            showPopover = false
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                                showPaywall = true
                            }
                        }) {
                            Text(NSLocalizedString("unlock_now", comment: ""))
                                .font(.system(size: 18, weight: .bold, design: .rounded))
                                .foregroundColor(.white)
                                .padding()
                                .background(Color("MainComponentColor"))
                                .cornerRadius(10)
                        }
                        .padding(.top, 20)
                    }
                    .padding()
                }
            }
        }
        .fullScreenCover(isPresented: $showPaywall) {
            PaywallView()
        }
        .navigationBarTitleDisplayMode(.inline)
        .alert(
            isPresented: Binding(
                get: { bikeVM.showAlert || maintenanceVM.showAlert || VM.showAlert },
                set: { newValue in
                    if !newValue {
                        bikeVM.showAlert = false
                        maintenanceVM.showAlert = false
                        VM.showAlert = false
                    }
                }
			)
		) {
			if bikeVM.showAlert {
				return Alert(
					title: Text(NSLocalizedString("bike_error", comment: "")),
					message: Text(bikeVM.error?.localizedDescription ?? NSLocalizedString("unknown_error", comment: "")),
					dismissButton: .default(Text("OK")) {
						bikeVM.showAlert = false
						bikeVM.error = nil
					}
				)
			} else if maintenanceVM.showAlert {
				return Alert(
					title: Text(NSLocalizedString("maintenance_error", comment: "")),
					message: Text(maintenanceVM.error?.localizedDescription ?? NSLocalizedString("unknown_error", comment: "")),
					dismissButton: .default(Text("OK")) {
						maintenanceVM.showAlert = false
						maintenanceVM.error = nil
					}
				)
			} else {
				return Alert(
					title: Text(NSLocalizedString("error_title", comment: "Title for error alert")),
					message: Text(VM.error?.localizedDescription ?? NSLocalizedString("unknown_error", comment: "Fallback unknown error")),
					dismissButton: .default(Text("OK")) {
						VM.showAlert = false
						VM.error = nil
					}
				)
			}
		}
	}
}

