//
//  MaintenanceDetailsBackgroundView.swift
//  CarCare
//
//  Created by Ordinateur elena on 24/10/2025.
//

import SwiftUI

struct MaintenanceDetailsBackgroundView: View {
    let formattedDate: String
        let isLast: Bool
    
    var body: some View {
        HStack(alignment: .top, spacing: 15) {
            VStack {
                ZStack {
                    Rectangle()
                        .fill(
                            LinearGradient(
                                colors: [Color("InputSurfaceColor").opacity(1), Color.gray.opacity(0.2)],
                                startPoint: .top,
                                endPoint: .bottom
                            )
                        )
                        .frame(width: 2, height: 50)
                        .opacity(isLast ? 0 : 1)
                        .offset(y: 20)
                        .padding(.leading, 15)

                    VStack {
                        Circle()
                            .fill(Color("InputSurfaceColor"))
                            .frame(width: 12, height: 12)
                            .shadow(color: Color("InputSurfaceColor").opacity(0.7), radius: 4)
                            .overlay(
                                Circle()
                                    .stroke(Color.brown, lineWidth: 3)
                            )
                            .offset(y: -2)
                            .padding(.leading, 15)
                            .accessibilityLabel("Maintenance entry")
                    }
                }
            }
            
            HStack {
                Text(formattedDate)
                    .font(.system(size: 16, weight: .bold, design: .default))
                    .foregroundColor(Color("TextColor"))
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 12)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color("FirstSectionMaintenanceColor"))
                    .shadow(color: .black.opacity(0.05), radius: 4, x: 0, y: 2)
                    .padding(.trailing, 15)
            )
        }
    }
}

#Preview {
    MaintenanceDetailsBackgroundView(formattedDate: "24 oct. 2025", isLast: false)
}
