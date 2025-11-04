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
  Privacy Policy \n
  This application does not collect any personal data. All information used by the app remains solely on your device. No data is transmitted to any server or third party.\n
  Legal Notice / Terms of Use\n
  Use of this application is at your own risk. The publisher cannot be held responsible for any loss or damage resulting from the use of the application.
  """)
				.font(.body)
                .accessibilityLabel(Text("""
                  Privacy Policy \n
                  This application does not collect any personal data. All information used by the app remains solely on your device. No data is transmitted to any server or third party.\n
                  Legal Notice / Terms of Use\n
                  Use of this application is at your own risk. The publisher cannot be held responsible for any loss or damage resulting from the use of the application.
                """))
                .accessibilityHint(Text("This section provides legal information about the application"))
            }
            .padding()
		}
		.navigationTitle("Mentions légales")
        .accessibilityAddTraits(.isHeader)
        .onAppear {
            let haptic = UIImpactFeedbackGenerator(style: .medium)
            haptic.impactOccurred()
        }
	}
}

#Preview {
	LegalView()
}
