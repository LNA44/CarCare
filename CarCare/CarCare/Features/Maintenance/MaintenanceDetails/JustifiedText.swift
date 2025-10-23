//
//  JustifiedText.swift
//  CarCare
//
//  Created by Ordinateur elena on 29/09/2025.
//

import SwiftUI

struct JustifiedText: UIViewRepresentable {
	let text: String
	let font: UIFont
	let textColor: UIColor

	func makeUIView(context: Context) -> UILabel {
		let label = UILabel()
		label.numberOfLines = 0
		label.lineBreakMode = .byWordWrapping
		label.textAlignment = .justified
		label.font = font
		label.textColor = textColor
		return label
	}

	func updateUIView(_ uiView: UILabel, context: Context) {
		uiView.text = text
	}
}

#Preview {
	JustifiedText(
		text: "Hello world, this is justified text example.",
		font: UIFont.systemFont(ofSize: 16, weight: .regular),
		textColor: UIColor.blue
	)
	.frame(width: 200)
}
