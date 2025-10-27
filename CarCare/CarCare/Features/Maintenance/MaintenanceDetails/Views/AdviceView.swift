//
//  AdviceView.swift
//  CarCare
//
//  Created by Ordinateur elena on 27/10/2025.
//

import SwiftUI

struct AdviceView: View {
    var maintenance: Maintenance
    
    var body: some View {
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
                .padding(.horizontal, 15)
                .multilineTextAlignment(.center)
                .frame(maxWidth: .infinity)
            Spacer()
        }
        .background(Color("BackgroundColor"))
    }
}

#Preview {
    AdviceView(maintenance: Maintenance(id: UUID(),
                                        maintenanceType: .BleedHydraulicBrakes,
                                        date: Date(),      // date actuelle
                                        reminder: true))
}
