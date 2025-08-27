//
//  PrimaryButton.swift
//  CarCare
//
//  Created by Ordinateur elena on 27/08/2025.
//

import SwiftUI

struct PrimaryButton: View {
	let title: String
	let font: Font
	let foregroundColor: Color
	let backgroundColor: Color
	let action: () -> Void
	
	var body: some View {
		Button(action: action) {
			Text(title)
				.font(font)
				.foregroundColor(foregroundColor)
				.frame(maxWidth: .infinity)
				.padding()
				.background(backgroundColor)
				.cornerRadius(10)
		}
	}
}

/*#Preview {
    PrimaryButton()
}*/
