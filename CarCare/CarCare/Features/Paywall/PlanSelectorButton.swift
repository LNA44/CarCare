//
//  PlanSelectorButton.swift
//  CarCare
//
//  Created by Ordinateur elena on 14/09/2025.
//

import SwiftUI

struct SubscriptionButton: View {
	let title: String
	let price: String
	let isSelected: Bool
	let action: () -> Void
    let haptic = UIImpactFeedbackGenerator(style: .medium)
	
	var body: some View {
        Button(action: {
            haptic.impactOccurred()
            action()
        }) {
            HStack {
                VStack(alignment: .leading, spacing: 2) {
                    Text(title)
                        .font(.system(size: 18, weight: .bold, design: .default))
                        .lineLimit(1)
                        .minimumScaleFactor(0.8)
                    Text(price)
                        .font(.system(size: 14, weight: .medium, design: .default))
                        .lineLimit(1)
                        .minimumScaleFactor(0.8)
                        .foregroundColor(.secondary)
                }
                Spacer()
                Image(systemName: isSelected ? "checkmark.circle.fill" : "circle")
                    .foregroundColor(isSelected ? Color("AppPrimaryColor") : .gray)
                    .imageScale(.large)
                    .accessibilityHidden(true)
            }
            .padding()
            .frame(maxWidth: .infinity)
            .background(isSelected ? Color("AppPrimaryColor").opacity(0.1) : Color.gray.opacity(0.1))
            .cornerRadius(12)
            .accessibilityElement(children: .ignore) // Combine title, price, and selection into one element
            .accessibilityLabel("\(title), \(price)")
            .accessibilityHint("Double tap to select this subscription plan")
            .accessibilityValue(isSelected ? "Selected" : "Not selected")
            .accessibilityAddTraits(.isButton)
        }
    }
}
/*#Preview {
    PlanSelectorButton()
}*/
