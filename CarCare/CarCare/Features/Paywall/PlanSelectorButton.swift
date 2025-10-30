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
		/*Button(action: action) {
			HStack {
				VStack(alignment: .leading, spacing: 2) {
					Text(title)
						.font(.system(size: 18, weight: .bold, design: .rounded))
						.lineLimit(1)
						.minimumScaleFactor(0.8)
					Text(price)
						.font(.system(size: 14, weight: .medium, design: .rounded))
						.lineLimit(1)
						.minimumScaleFactor(0.8)
						.foregroundColor(.secondary)
				}
				Spacer()
				Image(systemName: isSelected ? "checkmark.circle.fill" : "circle")
					.foregroundColor(isSelected ? Color("AppPrimaryColor") : .gray)
					.imageScale(.large)
			}
			.padding()
			.frame(maxWidth: .infinity)
			.background(isSelected ? Color("AppPrimaryColor").opacity(0.1) : Color.gray.opacity(0.1))
			.cornerRadius(12)
		}*/
        Button(action: {
            haptic.impactOccurred()
            action()
        }) {
            HStack {
                VStack(alignment: .leading, spacing: 2) {
                    Text(title)
                        .font(.system(size: 18, weight: .bold, design: .rounded))
                        .lineLimit(1)
                        .minimumScaleFactor(0.8)
                    Text(price)
                        .font(.system(size: 14, weight: .medium, design: .rounded))
                        .lineLimit(1)
                        .minimumScaleFactor(0.8)
                        .foregroundColor(.secondary)
                }
                Spacer()
                Image(systemName: isSelected ? "checkmark.circle.fill" : "circle")
                    .foregroundColor(isSelected ? Color("AppPrimaryColor") : .gray)
                    .imageScale(.large)
            }
            .padding()
            .frame(maxWidth: .infinity)
            .background(isSelected ? Color("AppPrimaryColor").opacity(0.1) : Color.gray.opacity(0.1))
            .cornerRadius(12)
        }
	}
}
/*#Preview {
    PlanSelectorButton()
}*/
