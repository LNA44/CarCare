//
//  MaintenanceDetailsView.swift
//  CarCare
//
//  Created by Ordinateur elena on 19/08/2025.
//

import SwiftUI

struct MaintenanceDetailsView: View {
	@AppStorage("isDarkMode") private var isDarkMode: Bool = false
	@Environment(\.dismiss) private var dismiss
	@ObservedObject var bikeVM: BikeVM // utile pour l'injecter dans AddMaintenanceView
	@ObservedObject var maintenanceVM: MaintenanceVM
	@ObservedObject var notificationVM: NotificationViewModel
	@StateObject private var VM: MaintenanceDetailsVM
	let maintenanceID: UUID // on reçoit juste l'ID
	@State private var showAddMaintenance = false
	@State private var maintenancesForOneType: [Maintenance] = []
	@State private var daysRemaining: Int?
	@State private var hasTriggeredHaptic = false
	var onAdd: () -> Void
	
	//MARK: -Initialization
	init(bikeVM: BikeVM, maintenanceVM: MaintenanceVM, maintenanceID: UUID, onAdd: @escaping () -> Void, notificationVM: NotificationViewModel) {
		self.bikeVM = bikeVM
		self.maintenanceVM = maintenanceVM
		self.notificationVM = notificationVM
		_VM = StateObject(wrappedValue: MaintenanceDetailsVM(maintenanceVM: maintenanceVM))
		self.maintenanceID = maintenanceID
		self.onAdd = onAdd
	}
	
	//MARK: -Body
	var body: some View {
		if let maintenance = maintenanceVM.maintenances.first(where: { $0.id == maintenanceID }) {
			ScrollView {
				VStack(spacing: 20) {
                    VStack {
                        ZStack {
                            if let daysRemaining = daysRemaining {
                                RoundedRectangle(cornerRadius: 15)
                                    .fill(
                                        
                                        LinearGradient(
                                            colors: [
                                                color(for: daysRemaining, frequency: maintenance.maintenanceType.frequencyInDays).opacity(0.9),
                                                color(for: daysRemaining, frequency: maintenance.maintenanceType.frequencyInDays).opacity(0.25)
                                            ],
                                            startPoint: .topLeading,
                                            endPoint: .bottomTrailing
                                        )
                                    )
                                
                                    .background(
                                        .ultraThinMaterial,
                                        in: RoundedRectangle(cornerRadius: 15)
                                    )
                            }
                            VStack {
                                ZStack {
                                    RoundedRectangle(cornerRadius: 18, style: .continuous)
                                        .fill(Color.white)
                                        .background(
                                            .ultraThinMaterial,
                                            in: RoundedRectangle(cornerRadius: 18, style: .continuous)
                                        )
                                    
                                    Image(maintenance.maintenanceType.iconName)
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 32, height: 32)
                                        .scaleEffect(iconScale(for: maintenance.maintenanceType))
                                }
                                .frame(width: 60, height: 60)
                                
                                if let daysRemaining = daysRemaining {
                                    Text(
                                        NSLocalizedString(message(for: daysRemaining, frequency: maintenance.maintenanceType.frequencyInDays), comment: "")
                                    )
                                    .padding(.horizontal, 10)
                                    .padding(.top, 5)
                                    .font(.system(size: 16, weight: .bold, design: .rounded))
                                    .multilineTextAlignment(.center)
                                    .foregroundColor(.white)
                                    .onAppear {
                                        triggerHaptic(maintenance: maintenance, for: daysRemaining)
                                    }
                                }
                            }
                            .padding(.vertical, 15)
                        }
                        
                        HStack(spacing: 20) {
                            VStack {
                                VStack(spacing: 15) {
                                    if let daysSince = maintenanceVM.calculateDaysSinceLastMaintenance(
                                        for: maintenance.maintenanceType
                                    ) {
                                        let frequency = Double(maintenance.maintenanceType.frequencyInDays)
                                        let progress = min(Double(daysSince) / frequency, 1.0)
                                        
                                        CircularProgressView(targetProgress: progress, value: daysSince)
                                        
                                        Text("\(daysSince)/ \(Int(frequency))j")
                                            .font(.system(size: 16, weight: .bold, design: .rounded))
                                            .foregroundStyle(Color("TextColor"))
                                        
                                    } else {
                                        CircularProgressView(
                                            targetProgress: 0.0,
                                            value: 0
                                        )
                                    }
                                }
                                .padding(.top, 5)
                            }
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                            .padding(15)
                            .background(
                                RoundedRectangle(cornerRadius: 15)
                                    .fill(
                                        LinearGradient(
                                            colors: [
                                                Color("AdviceColor").opacity(0.9),
                                                Color("AdviceColor").opacity(0.15)
                                            ],
                                            startPoint: .topLeading,
                                            endPoint: .bottomTrailing
                                        )
                                    )
                                    .background(
                                        .ultraThinMaterial,
                                        in: RoundedRectangle(cornerRadius: 15)
                                    )
                            )
                            .cornerRadius(15)
                            
                            VStack(alignment: .leading, spacing: 5) {
                                Text(NSLocalizedString("frequency_key", comment: ""))
                                    .bold()
                                    .frame(maxWidth: .infinity, alignment: .center)
                                    .font(.system(size: 14, weight: .bold, design: .rounded))
                                
                                Text("\(maintenance.maintenanceType.readableFrequency)")
                                    .frame(maxWidth: .infinity, alignment: .center)
                                    .font(.system(size: 18, weight: .regular, design: .rounded))
                                
                                Toggle("", isOn: Binding(
                                    get: { maintenance.reminder }, //appelé lors du dessin de la vue (aussi après modif du toggle pour redessiner la vue)
                                    set: { newValue in //modification du toggle
                                        maintenanceVM.updateReminder(for: maintenance, value: newValue)
                                        notificationVM.updateReminder(for: maintenance.id, value: newValue)
                                    }
                                ))
                                .frame(maxWidth: .infinity)
                                .padding(.top, 10)
                                .tint(Color("DoneColor"))
                                .labelsHidden()
                            }
                            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
                            .foregroundColor(Color("TextColor"))
                            .padding(15)
                            .background(
                                RoundedRectangle(cornerRadius: 15)
                                    .fill(
                                        LinearGradient(
                                            colors: [
                                                Color("AdviceColor").opacity(0.9),
                                                Color("AdviceColor").opacity(0.15)
                                            ],
                                            startPoint: .topLeading,
                                            endPoint: .bottomTrailing
                                        )
                                    )
                                    .background(
                                        .ultraThinMaterial,
                                        in: RoundedRectangle(cornerRadius: 15)
                                    )
                            )
                            .cornerRadius(15)
                        }
                        .padding(.top, 15)
                        
                    }
                    .padding(.vertical, 20)
                    .padding(.horizontal, 20)
                    .frame(maxWidth: .infinity)
                    .background(
                        Color("FirstSectionMaintenanceColor")
                    )
                    .cornerRadius(15)
                    .shadow(color: .black.opacity(0.2), radius: 8, x: 0, y: 4)
                    
                    VStack(spacing: 15) {
                        NavigationLink(
                            destination: AdviceView(maintenance: maintenance)
                        ) {
                            HStack {
                                VStack {
                                    Text(NSLocalizedString("advice_and_information_key", comment: ""))
                                        .font(.system(size: 25, weight: .bold, design: .rounded))
                                        .foregroundColor(Color("TextColor"))
                                    
                                    Divider()
                                        .frame(width: 200)
                                        .padding(.bottom, 10)
                                    
                                    Text("\(maintenance.maintenanceType.localizedDescription)")
                                        .font(.system(size: 16, weight: .regular, design: .rounded))
                                        .foregroundColor(Color("TextColor"))
                                        .padding(.leading, 15)
                                        .multilineTextAlignment(.center)
                                        .frame(maxWidth: .infinity)
                                        .lineLimit(3)
                                }
                                Image(systemName: "chevron.right")
                                    .padding(.top, 65)
                            }
                        }
                    }
                    .padding(.vertical, 20)
                    .padding(.bottom, 10)
                    .padding(.trailing, 10)
                    .background(Color("AdviceColor"))
                    .cornerRadius(15)
                    
                    
                    VStack {
                        Text(NSLocalizedString("maintenance_history_key", comment: ""))
                            .font(.system(size: 25, weight: .bold, design: .rounded))
                            .foregroundColor(Color("TextColor"))
                            .drawingGroup()
                        
                        Divider()
                            .frame(width: 200)
                        
                        VStack(alignment: .center, spacing: 0) {
                            ForEach(Array(maintenancesForOneType.enumerated()), id: \.element.id) { index, item in
                                MaintenanceDetailsBackgroundView(
                                    formattedDate: formattedDate(item.date),
                                    isLast: index == maintenancesForOneType.count - 1
                                )
                            }
                            
                            NavigationLink(
                                destination: AddMaintenanceView(bikeVM: bikeVM, maintenanceVM: maintenanceVM,  onAdd: onAdd, notificationVM: notificationVM)
                            ) {
                                Text(NSLocalizedString("button_update_key", comment: ""))
                                    .font(.system(size: 16, weight: .bold, design: .rounded))
                                    .foregroundColor(Color(.white))
                                    .frame(maxWidth: .infinity)
                                    .padding()
                                    .background(Color("AppPrimaryColor"))
                                    .cornerRadius(10)
                            }
                            .padding(.horizontal, 15)
                            .padding(.top, 15)
                            .shadow(color: .black.opacity(0.25), radius: 5, x: 0, y: 2)
                        }
                        .padding(.top, 10)
                    }
                    .frame(maxWidth: .infinity, alignment: .center)
                    .padding(.vertical, 20)
                    .padding(.bottom, 10)
                    .background(Color("MaintenanceHistoryColor"))
                    .cornerRadius(15)
				}
				.padding(.top, 15)
				.background(Color("BackgroundColor"))
				.cornerRadius(15)
				.padding(.horizontal, 10)
				.onAppear {
					_ = VM.fetchAllMaintenanceForOneType(type: maintenance.maintenanceType)
				}
				Spacer()
			}
			.onAppear {
				maintenancesForOneType = VM.fetchAllMaintenanceForOneType(type: maintenance.maintenanceType)
				daysRemaining = VM.daysUntilNextMaintenance(type: maintenance.maintenanceType)
			}
			.onChange(of: maintenanceVM.maintenances) {_, _ in
				if let maintenance = maintenanceVM.maintenances.first(where: { $0.id == maintenanceID }) {
					maintenancesForOneType = VM.fetchAllMaintenanceForOneType(type: maintenance.maintenanceType)
					daysRemaining = VM.daysUntilNextMaintenance(type: maintenance.maintenanceType)
				}
			}
			.background(Color("BackgroundColor"))
			.navigationBarBackButtonHidden(true)
				
			.toolbar {
				ToolbarItem(placement: .navigationBarLeading) {
					Button(action: {
						dismiss()
					}) {
						Text(NSLocalizedString("return_key", comment: ""))
							.font(.system(size: 16, weight: .regular, design: .rounded))
							.foregroundColor(Color("TextColor"))
					}
				}
				ToolbarItem(placement: .principal) {
					Text("\(maintenance.maintenanceType.localizedName)")
						.font(.system(size: 22, weight: .bold, design: .rounded))
						.foregroundColor(Color("TextColor"))
				}
			}
			.alert(
				isPresented: Binding(
					get: { maintenanceVM.showAlert || VM.showAlert },
					set: { newValue in
						if !newValue {
							maintenanceVM.showAlert = false
							VM.showAlert = false
						}
					}
				)
			) {
				if maintenanceVM.showAlert {
					return Alert(
						title: Text(NSLocalizedString("error_title", comment: "Title for error alert")),
						message: Text(maintenanceVM.error?.localizedDescription ?? NSLocalizedString("unknown_error", comment: "Fallback unknown error")),
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
		} else {
			Text("Maintenance introuvable")
		}
	}
}

extension MaintenanceDetailsView {
	func message(for days: Int, frequency: Int) -> String {
		let proportion = min(max(Double(frequency - days) / Double(frequency), 0), 1)

		switch proportion {
		case 0..<1/3:
			return "maintenance_message_up_to_date"
		case 1/3..<2/3:
			return "maintenance_message_not_yet"
		default:
			return "maintenance_message_due"
		}
	}
	
	func color(for days: Int, frequency: Int) -> Color {
		let proportion = min(max(Double(frequency - days) / Double(frequency), 0), 1)

		switch proportion {
		case 0..<1/3:
			return Color("DoneColor")
		case 1/3..<2/3:
			return Color("InProgressColor")
		default:
			return Color("ToDoColor")
		}
	}
	
	func formattedDate(_ date: Date) -> String {
		let formatter = DateFormatter()
		formatter.dateStyle = .medium
		formatter.timeStyle = .none
		formatter.locale = Locale.current  
		return formatter.string(from: date)
	}
	
	private func triggerHaptic(maintenance: Maintenance, for days: Int) { //vibrations en fonction de l'état de la maintenance
		let proportion = Double(maintenance.maintenanceType.frequencyInDays - days) / Double(maintenance.maintenanceType.frequencyInDays)
		
		if proportion < 1/3 {
			UISelectionFeedbackGenerator().selectionChanged()
		} else if proportion < 2/3 {
			UIImpactFeedbackGenerator(style: .light).impactOccurred()
		} else {
			UINotificationFeedbackGenerator().notificationOccurred(.warning)
		}
	}
}

extension MaintenanceDetailsView {
	func iconScale(for type: MaintenanceType) -> CGFloat {
		switch type {
		case .CleanDrivetrain:
			return 0.85
		case .RunSoftwareAndBatteryDiagnostics:
			return 0.8
		default:
			return 1.0
		}
	}
}

