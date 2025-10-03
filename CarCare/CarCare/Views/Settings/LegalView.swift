//
//  LegalView.swift
//  CarCare
//
//  Created by Ordinateur elena on 25/08/2025.
//

import SwiftUI

struct LegalView: View {
	var body: some View {
		ScrollView {
			VStack(alignment: .leading, spacing: 15) {
				Text("""
  Publisher: Independent Developer
  Address: Pays De La Loire, France
  Email: contact@monsite.fr
  Publication Director: Not applicable
  Hosting: Not applicable, local application
  Intellectual Property:
  All content and code of this application are protected.
  Personal Data Protection:
  This application does not collect any personal data. All information entered remains on the user’s device.
  """)
				.font(.body)
			}
			.padding()
		}
		.navigationTitle("Mentions légales")
	}
}

#Preview {
	LegalView()
}
