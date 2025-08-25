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
  Éditeur : Développeur indépendant
  Adresse : Pays De La Loire
  Email : contact@monsite.fr
  
  Directeur de la publication : Non applicable
  
  Hébergement : Non applicable, application locale
  
  Propriété intellectuelle :
  Tout le contenu et le code de cette application sont protégés.
  
  Protection des données personnelles :
  Cette application ne collecte pas de données personnelles. Toutes les informations saisies restent sur l'appareil de l'utilisateur.
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
