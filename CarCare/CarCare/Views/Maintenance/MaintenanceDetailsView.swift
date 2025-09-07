//
//  MaintenanceDetailsView.swift
//  CarCare
//
//  Created by Ordinateur elena on 19/08/2025.
//

import SwiftUI

struct MaintenanceDetailsView: View {
	@Environment(\.dismiss) private var dismiss
	@ObservedObject var bikeVM: BikeVM // utile pour l'injecter dans AddMaintenanceView
	@ObservedObject var maintenanceVM: MaintenanceVM
	@StateObject private var VM: MaintenanceDetailsVM
	let maintenanceID: UUID // on reçoit juste l'ID
	//@State var currentMaintenance: Maintenance?
	@State private var showAddMaintenance = false
	@State private var maintenancesForOneType: [Maintenance] = []
	@State private var daysRemaining: Int?
	@State private var hasTriggeredHaptic = false
	
	//MARK: -Initialization
	init(bikeVM: BikeVM, maintenanceVM: MaintenanceVM, maintenanceID: UUID) {
		self.bikeVM = bikeVM
		self.maintenanceVM = maintenanceVM
		_VM = StateObject(wrappedValue: MaintenanceDetailsVM(maintenanceVM: maintenanceVM))
		self.maintenanceID = maintenanceID
	}
	
	//MARK: -Body
	var body: some View {
		if let maintenance = maintenanceVM.maintenances.first(where: { $0.id == maintenanceID }) {
			ScrollView {
				VStack(spacing: 20) {
					VStack {
						Image(maintenance.maintenanceType.iconName)
							.resizable()
							.scaledToFit()
							.frame(width: 80, height: 80)
							.scaleEffect(maintenance.maintenanceType == .Battery ? 0.8 : 1.0) // exemple
							.padding(10)
							.background(Color("BackgroundColor"))
							.clipShape(Circle())
						
						VStack(spacing: 50) {
							VStack {
								VStack(spacing: 20) {
									if let daysRemaining = daysRemaining {
										DaysIndicatorView(days: daysRemaining, frequency: maintenance.maintenanceType.frequencyInDays, rectangleWidth: 40, rectangleHeight: 20, triangleWidth: 10, triangleHeight: 10, spacing: 4)
										Text(
											NSLocalizedString(message(for: daysRemaining, frequency: maintenance.maintenanceType.frequencyInDays), comment: "")
										)
											.font(.system(size: 16, weight: .bold, design: .rounded))
											.multilineTextAlignment(.center)
											.foregroundColor(color(for: daysRemaining, frequency: maintenance.maintenanceType.frequencyInDays))
											.onAppear {
												triggerHaptic(maintenance: maintenance, for: daysRemaining)
											}
									}
								}
								.padding(.top, 20)
							}
							.padding(.horizontal, 15)
							
							
							HStack {
								Image(systemName: "alarm") // icône réveil
									.foregroundColor(Color("TextColor"))  // couleur de l'icône
								
								Text(String(
									format: NSLocalizedString("frequency_key", comment: "Label pour la fréquence de maintenance"),
									maintenance.maintenanceType.readableFrequency
								))
									.font(.system(size: 16, weight: .bold, design: .rounded))
									.foregroundColor(Color("TextColor"))
								
								Spacer()
								
								Toggle("", isOn: Binding(
									get: { maintenance.reminder }, //appelé lors du dessin de la vue (aussi après modif du toggle pour redessiner la vue)
									set: { newValue in //modification du toggle
										maintenanceVM.updateReminder(for: maintenance, value: newValue)
									}
								))
								.tint(Color("DoneColor"))
								.labelsHidden()
							}
							.padding(.horizontal, 20)
							
							NavigationLink(
								destination: AddMaintenanceView(bikeVM: bikeVM, maintenanceVM: maintenanceVM, onAdd: {
									//maintenanceVM.fetchAllMaintenance() //closure appelée après dismiss
								})
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
							.shadow(color: .black.opacity(0.25), radius: 5, x: 0, y: 2)
						}
						
					}
					.padding(.vertical, 20)
					.background(Color.white)
					.cornerRadius(15)
					.shadow(color: .black.opacity(0.2), radius: 8, x: 0, y: 4)
					
					VStack {
						Text(NSLocalizedString("maintenance_history_key", comment: ""))
							.font(.system(size: 25, weight: .bold, design: .rounded))
							.foregroundColor(Color("TextColor"))
							.drawingGroup()
						
						Divider()
							.frame(width: 200)
						
						VStack(alignment: .leading, spacing: 0) {
							ForEach(Array(maintenancesForOneType.reversed().enumerated()), id: \.element.id) { index, item in
								
								VStack {
									HStack {
										Image(systemName: "wrench")
										Text("\(formattedDate(item.date))")
											.padding(.leading, 8)
											.font(.system(size: 16, weight: .bold, design: .rounded))
											.foregroundColor(Color("TextColor"))
									}
									HStack {
										if index != maintenancesForOneType.count - 1 {
											Rectangle()
												.fill(Color("AppPrimaryColor"))
												.frame(width: 2)
												.frame(height: 10)
												.padding(.bottom, 5)
										}
										Spacer()
									}
									.padding(.leading, 130)
								}
							}
						}
						.padding(.top, 10)
					}
					.padding(.vertical, 20)
					.padding(.bottom, 10)
					.background(Color("MaintenanceHistoryColor"))
					.cornerRadius(15)
					
					VStack(spacing: 15) {
						Text(NSLocalizedString("advice_and_information_key", comment: ""))
							.font(.system(size: 25, weight: .bold, design: .rounded))
							.foregroundColor(Color("TextColor"))
						
						Divider()
							.frame(width: 200)
						
						Text("\(maintenance.maintenanceType.localizedDescription)")
							.font(.system(size: 16, weight: .regular, design: .rounded))
							.foregroundColor(Color("TextColor"))
							.padding(.leading, 20)
							.frame(maxWidth: .infinity, alignment: .leading) // aligné à gauche
					}
					.padding(.vertical, 20)
					.padding(.bottom, 10)
					.background(Color("AdviceColor"))
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
			.alert(isPresented: $maintenanceVM.showAlert) {
				Alert(
					title: Text(NSLocalizedString("error_title", comment: "Title for error alert")),
					message: Text(maintenanceVM.error?.localizedDescription ?? NSLocalizedString("unknown_error", comment: "Fallback unknown error")),
					dismissButton: .default(Text("OK")) {
						bikeVM.showAlert = false
						bikeVM.error = nil
					}
				)
			}
			.alert(isPresented: $VM.showAlert) {
				Alert(
					title: Text(NSLocalizedString("error_title", comment: "Title for error alert")),
					message: Text(VM.error?.localizedDescription ?? NSLocalizedString("unknown_error", comment: "Fallback unknown error")),
					dismissButton: .default(Text("OK")) {
						bikeVM.showAlert = false
						bikeVM.error = nil
					}
				)
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

/*#Preview {
 MaintenanceDetailsView()
 }*/


