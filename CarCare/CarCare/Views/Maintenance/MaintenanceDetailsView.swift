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
						VStack(spacing: 50) {
							VStack {
								VStack(spacing: 20) {
									if let daysRemaining = daysRemaining {
										DaysIndicatorView(days: daysRemaining, frequency: maintenance.maintenanceType.frequencyInDays, rectangleWidth: 40, rectangleHeight: 20, triangleWidth: 10, triangleHeight: 10, spacing: 4)
										Text("\(message(for: daysRemaining, frequency: maintenance.maintenanceType.frequencyInDays))")
											.multilineTextAlignment(.center)
											.foregroundColor(color(for: daysRemaining, frequency: maintenance.maintenanceType.frequencyInDays))
									}
								}
								.padding(15)
								.frame(maxWidth: 350)
								.background(
									Color("BackgroundColor")
										.cornerRadius(15)
								)
								.overlay(
									RoundedRectangle(cornerRadius: 15)
										.stroke(Color("InputSurfaceColor"), lineWidth: 2)
								)
							}
							.padding(.horizontal, 15)
							
							
							HStack {
								Image(systemName: "alarm") // icône réveil
									.foregroundColor(.black)  // couleur de l'icône
								
								Text("Fréquence : \(maintenance.maintenanceType.readableFrequency)")
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
								Text("Mettre à jour")
									.font(.system(size: 16, weight: .bold, design: .rounded))
									.foregroundColor(Color("TextColor"))
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
					.background(Color("StackBackgroundColor"))
					.cornerRadius(15)

					VStack {
						Text("Historique des entretiens")
							.font(.system(size: 25, weight: .bold, design: .rounded))
							.foregroundColor(Color("TextColor"))
							.padding(.bottom, 20)
							.drawingGroup()
						
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
						.padding(.top, 15)
					}
					.padding(.vertical, 20)
					.padding(.bottom, 10)
					.background(Color("StackBackgroundColor"))
					.cornerRadius(15)
					
					/*Divider()
						.frame(width: 200, height: 1)
						.background(Color.gray.opacity(0.2)) // couleur du trait
						.padding(.vertical, 20)*/
					
					VStack(spacing: 20) {
						Text("Conseils & infos")
							.font(.system(size: 25, weight: .bold, design: .rounded))
							.foregroundColor(Color("TextColor"))
							.padding(.bottom, 20)
						
						Text("\(maintenance.maintenanceType.description)")
							.font(.system(size: 16, weight: .regular, design: .rounded))
							.foregroundColor(Color("TextColor"))
							.padding(.leading, 20)
							.frame(maxWidth: .infinity, alignment: .leading) // aligné à gauche
					}
					.padding(.vertical, 20)
					.padding(.bottom, 10)
					.background(Color("StackBackgroundColor"))
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
						Text("Retour")
							.font(.system(size: 16, weight: .regular, design: .rounded))
							.foregroundColor(Color("TextColor"))
					}
				}
				ToolbarItem(placement: .principal) {
					Text("\(maintenance.maintenanceType.rawValue)")
						.font(.system(size: 22, weight: .bold, design: .rounded))
						.foregroundColor(Color("TextColor"))
				}
			}
			.alert(isPresented: $maintenanceVM.showAlert) {
				Alert(
					title: Text("Erreur"),
					message: Text(maintenanceVM.error?.errorDescription ?? "Erreur inconnue"),
					dismissButton: .default(Text("OK")) {
						maintenanceVM.showAlert = false
						maintenanceVM.error = nil
					}
				)
			}
			.alert(isPresented: $VM.showAlert) {
				Alert(
					title: Text("Erreur"),
					message: Text(VM.error?.errorDescription ?? "Erreur inconnue"),
					dismissButton: .default(Text("OK")) {
						VM.showAlert = false
						VM.error = nil
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
			return "Tu es à jour"
		case 1/3..<2/3:
			return "Tu n'as pas encore à t'en préoccuper"
		default:
			return "C'est l'heure! Pense à prendre rendez-vous chez le réparateur le plus proche"
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
		formatter.dateFormat = "dd/MM/yyyy"
		return formatter.string(from: date)
	}
}

/*#Preview {
 MaintenanceDetailsView()
 }*/


