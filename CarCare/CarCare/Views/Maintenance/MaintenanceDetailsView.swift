//
//  MaintenanceDetailsView.swift
//  CarCare
//
//  Created by Ordinateur elena on 19/08/2025.
//

import SwiftUI

struct MaintenanceDetailsView: View {
	@Environment(\.dismiss) private var dismiss
	@EnvironmentObject var maintenanceVM: MaintenanceVM
	let maintenanceID: UUID // on reçoit juste l'ID
	var maintenance: Maintenance? { // computed property : on retrouve la "vraie" donnée à partir du viewModel
		maintenanceVM.maintenances.first(where: { $0.id == maintenanceID })
	}
	@State private var showAddMaintenance = false
	
	var body: some View {
		if let maintenance = maintenance {
			let daysRemaining = maintenanceVM.daysUntilNextMaintenance(type: maintenance.maintenanceType)
			
			ScrollView {
				VStack {
					VStack(spacing: 50) {
						VStack(spacing: 20) {
							Text("\(maintenance.maintenanceType.rawValue)")
								.font(.title)
								.bold()
								.padding(.bottom, 40)
							
							VStack(spacing: 20) {
								DaysIndicatorView(days: daysRemaining, rectangleWidth: 40, rectangleHeight: 20, triangleWidth: 10, triangleHeight: 10, spacing: 4)
								Text("\(message(for: daysRemaining))")
									.multilineTextAlignment(.center)
									.foregroundColor(color(for: daysRemaining))
									.padding(10)
							}
							.padding(.bottom, 20)
						}
						
						HStack {
							Image(systemName: "alarm") // icône réveil
									.foregroundColor(.black)  // couleur de l'icône
							
							Text("Fréquence : \(maintenance.maintenanceType.readableFrequency)")
							
							Spacer()
							
							Toggle("", isOn: Binding(
								get: { maintenance.reminder }, //appelé lors du dessin de la vue (aussi après modif du toggle pour redessiner la vue)
								set: { newValue in //modification du toggle
									maintenanceVM.updateReminder(for: maintenance, value: newValue)
								}
							))
							.labelsHidden()
						}
						.padding(.horizontal, 20)
						
						Button (action: {
							showAddMaintenance = true
						}) {
							Text("Mettre à jour")
								.frame(width: 290)
								.padding()
								.background(Color.blue.cornerRadius(10))
								.foregroundColor(.white)
								.padding(.horizontal)
						}
						
					}
					.sheet(isPresented: $showAddMaintenance) {
						AddMaintenanceView(showingSheet: $showAddMaintenance)
					}
					
					.padding(.vertical, 20)
					.background(.ultraThinMaterial) // carte translucide
					.cornerRadius(15) // coins arrondis
					.shadow(radius: 5) // ombre subtile
					
					.padding(20)
					
					Text("Historique des entretiens")
					
					VStack(alignment: .leading, spacing: 0) {
						ForEach(Array(maintenanceVM.maintenancesForOneType.enumerated()), id: \.element.id) { index, maintenanceItem in
							HStack {
								Spacer()
								VStack {
									
									Image(systemName: "wrench")
									
									if index != maintenanceVM.maintenancesForOneType.count - 1 {
										Rectangle()
											.fill(Color.gray)
											.frame(width: 2)
											.frame(height: 10)
											.padding(.bottom, 5)
									}
								}
								
								Text("\(formattedDate(maintenanceItem.date))")
									.padding(.leading, 8)
								
								Spacer()
							}
						}
					}
					.padding(.top, 15)
					
					
					Divider()
						.frame(width: 200, height: 1)
						.background(Color.gray.opacity(0.2)) // couleur du trait
						.padding(.vertical, 20)
					
					VStack(spacing: 20) {
						Text("Conseils & infos")
							.bold()
						Text("\(maintenance.maintenanceType.description)")
					}
					.padding(.bottom, 20)
				}
				.onAppear {
					maintenanceVM.fetchAllMaintenanceForOneType(type: maintenance.maintenanceType)
				}
				Spacer()
			}
			.navigationBarBackButtonHidden(true)
			.toolbar {
				ToolbarItem(placement: .navigationBarLeading) {
					Button("Retour") {
						dismiss()
					}
				}
			}
			
		} else {
			Text("Maintenance introuvable")
		}
	}
}

extension MaintenanceDetailsView {
	func message(for days: Int?) -> String {
		guard let days else { return "Nombre de jours inconnu" }
		
		switch days {
		case ..<1:
			return "C'est l'heure! Pense à prendre rendez-vous chez le réparateur le plus proche"
		case 1...30:
			return "Tu n'as pas encore à t'en préoccuper"
		default:
			return "Tu es à jour"
		}
	}
	
	func color(for days: Int?) -> Color {
		guard let days else { return .gray }
		
		switch days {
		case ..<1:
			return .red
		case 1..<30:
			return .orange
		default:
			return .green
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
