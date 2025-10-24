//
//  CircularProgressView.swift
//  CarCare
//
//  Created by Ordinateur elena on 24/10/2025.
//

import SwiftUI

struct CircularProgressView: View {
    let targetProgress: Double
    @State private var progress: Double = 0
    let value: Int
    let progressColor: Color = Color("TextColor")
    let backgroundColor: Color = .brown.opacity(0.6)
    
    var body: some View {
        ZStack {
            Circle()
                .stroke(backgroundColor, lineWidth: 9)
                .frame(width: 40, height: 40)
            
            Circle()
                .trim(from: 0, to: progress)
                .stroke(
                    progressColor,
                    style: StrokeStyle(
                        lineWidth: 9,
                        lineCap: .round
                    )
                )
                .frame(width: 40, height: 40)
                .rotationEffect(.degrees(-90))
        }
        .onAppear {
            withAnimation(.easeInOut(duration: 1.0)) {
                progress = targetProgress
            }
        }
    }
}
