//
//  Placeholder.swift
//  CarCare
//
//  Created by Ordinateur elena on 27/08/2025.
//

import SwiftUI

struct CustomTextField: View {
	var placeholder: String
	@Binding var text: String
	var font: Font = .custom("SpaceGrotesk-Regular", size: 16)
	var foregroundColor: Color = .brown
	var backgroundColor: Color = Color("InputSurfaceColor")
	var cornerRadius: CGFloat = 10
	var paddingValue: CGFloat = 10
	
	var body: some View {
		ZStack(alignment: .leading) {
			if text.isEmpty {
				Text(placeholder)
					.foregroundColor(.gray)
					.font(font)
					.padding(.horizontal, paddingValue)
			}
			TextField("", text: $text)
				.font(font)
				.foregroundColor(foregroundColor)
				.padding(paddingValue)
				.background(backgroundColor)
				.cornerRadius(cornerRadius)
		}
	}
}

/*#Preview {
	CustomTextField()
}*/
