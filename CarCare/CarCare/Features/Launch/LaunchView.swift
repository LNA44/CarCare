//
//  LaunchView.swift
//  CarCare
//
//  Created by Ordinateur elena on 03/11/2025.
//

import SwiftUI

struct LaunchView: View {
    var body: some View {
        VStack {
            Image("HelmetImage")
                .resizable()
                .scaledToFit()
                .frame(width: 100, height: 100)
                .offset(x: -2)
            
            Text("MyBikeMate")
                .font(.system(size: 18, weight: .bold, design: .default))
                .foregroundColor(Color("TextColor"))
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity) // prends tout l'espace disponible
        .background(Color("BackgroundColor"))
        .ignoresSafeArea()
    }
}

#Preview {
    LaunchView()
}
