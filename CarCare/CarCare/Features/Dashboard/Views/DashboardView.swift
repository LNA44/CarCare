//
//  DashboardViewE.swift
//  CarCare
//
//  Created by Ordinateur elena on 03/11/2025.
//

import SwiftUI

struct DashboardView: View {
    @AppStorage("isDarkMode") private var isDarkMode = false
    @AppStorage("isPremiumUser") private var isPremiumUser = false
    @ObservedObject var bikeVM: BikeVM
    @ObservedObject var maintenanceVM: MaintenanceVM
    @ObservedObject var notificationVM: NotificationViewModel
    @StateObject private var VM: DashboardVM
    @State private var sheetPosition: CGFloat = 0.5 // 0.5 = medium, 0.1 = large
    @State private var dragOffset: CGFloat = 0
    //@State private var goToAdd = false
    @State private var didLoadData = false
    @State private var showPaywall = false
    @State private var showPopover = false
    let haptic = UIImpactFeedbackGenerator(style: .medium)
    
    init(bikeVM: BikeVM, maintenanceVM: MaintenanceVM, notificationVM: NotificationViewModel) {
        self.bikeVM = bikeVM
        self.maintenanceVM = maintenanceVM
        self.notificationVM = notificationVM
        _VM = StateObject(wrappedValue: DashboardVM(maintenanceVM: maintenanceVM))
    }
    
    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .top) {
                if let imageData = bikeVM.bike?.imageData,
                   let uiImage = UIImage(data: imageData) {
                    Image(uiImage: uiImage)
                        .resizable()
                        .scaledToFill()
                        .frame(width: geometry.size.width, height: geometry.size.height)
                        .ignoresSafeArea()
                } else if bikeVM.bike == nil {
                    EmptyView()
                } else {
                    Image("Riding")
                        .resizable()
                        .scaledToFill()
                        .frame(width: geometry.size.width, height: geometry.size.height)
                        .ignoresSafeArea()
                }
                if didLoadData {
                    BikeDetailsSheet(bikeVM: bikeVM, maintenanceVM: maintenanceVM, notificationVM: notificationVM, VM: VM)
                        .frame(height: geometry.size.height)
                        .offset(y: (geometry.size.height * sheetPosition) + dragOffset)
                        .gesture(
                            DragGesture()
                                .onChanged { value in
                                    dragOffset = value.translation.height
                                }
                                .onEnded { value in
                                    withAnimation(.spring(response: 0.4, dampingFraction: 0.8)) {
                                        // Calculer la nouvelle position
                                        let newPosition = sheetPosition + (value.translation.height / geometry.size.height)
                                        
                                        // Snap vers medium (0.5) ou large (0.1)
                                        if newPosition < 0.3 {
                                            sheetPosition = 0.1 // Position haute
                                        } else if newPosition > 0.3 && newPosition < 0.6 {
                                            sheetPosition = 0.5 // Position moyenne
                                        } else {
                                            sheetPosition = 0.65 // Position basse
                                        }
                                        
                                        dragOffset = 0
                                    }
                                }
                        )
                }
            }
        }
        .onAppear {
            guard !didLoadData else { return } //evite boucle lors du changement de light dark mode
            didLoadData = true
            bikeVM.fetchBikeData() { //bikeData mises dans publised
                VM.fetchLastMaintenance(for: bikeVM.bikeType)
                maintenanceVM.fetchAllMaintenance(for: bikeVM.bikeType) //utile pour statut général entretien
            }
        }
        .ignoresSafeArea()
        .padding(.bottom, 40)
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
