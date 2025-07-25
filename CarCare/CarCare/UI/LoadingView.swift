//
//  LoadingView.swift
//  CarCare
//
//  Created by Ordinateur elena on 22/07/2025.
//

import SwiftUI

struct LoadingView: View {
	var body: some View {
		VStack(spacing: 20) {
			ProgressView()
				.progressViewStyle(CircularProgressViewStyle())
				.scaleEffect(1.5)
			Text("Chargement en cours...")
				.font(.headline)
				.foregroundColor(.gray)
		}
		.padding()
	}
}

#Preview {
	LoadingView()
}
