//
//  OnboardingView.swift
//  CarCare
//
//  Created by Ordinateur elena on 20/09/2025.
//

import SwiftUI

struct OnboardingView: View {
	@AppStorage("hasSeenOnboarding") private var hasSeenOnboarding = false
	@State private var currentIndex = 0
	@State private var showButton = false
	
	let questions = [
		"Bienvenue dans MyBikeMate !",
		"Tu utilises ton vélo au quotidien et tu en as marre de ne plus te rappeler quand programmer ton prochain entretien ?",
		"Tu veux vendre ton vélo et prouver le suivi d’entretien réalisé ?",
		"Tu veux partager l’historique d’entretien avec ton réparateur ?"
	]
	
	var body: some View {
		VStack(spacing: 40) {
			ForEach(questions.indices, id: \.self) { index in
				VStack {
					Text(questions[index])
						.font(currentIndex == index ? .system(size: 28, weight: .bold, design: .rounded) : .system(size: 18, weight: .bold, design: .rounded))
						.multilineTextAlignment(.center)
						.lineLimit(nil)               // ✅ permet plusieurs lignes
						.fixedSize(horizontal: false, vertical: true)
						.opacity(currentIndex >= index ? 1 : 0)
						.offset(x: offsetFor(index))
						.padding(.vertical, currentIndex == index ? 10 : 25)
						.animation(.easeInOut(duration: 0.8), value: currentIndex)
					
					
					if index == 0 && currentIndex >= 0 {
						AnimationView(name: "Cycling")
							.frame(width: 100, height: 100)
							.scaleEffect(currentIndex == index ? 1.2 : 0.6)
							.opacity(currentIndex >= index ? 1 : 0)
							.offset(x: offsetFor(index))                  
							.animation(.easeInOut(duration: 0.8), value: currentIndex)
					}
				}
			}
			
			Spacer()
			
			if currentIndex < questions.count {
				Button(action: {
					if currentIndex < questions.count - 1 {
						withAnimation {
							currentIndex += 1
						}
					} else {
						hasSeenOnboarding = true
					}
				}) {
					Text(currentIndex < questions.count - 1 ? "Suivant" : "Commencer")
						.font(.system(size: 16, weight: .bold, design: .rounded))
						.frame(maxWidth: .infinity)
						.padding()
						.background(Color("AppPrimaryColor"))
						.foregroundColor(.white)
						.cornerRadius(12)
				}
				.padding(.horizontal)
				.transition(.opacity)
				.animation(.easeInOut, value: currentIndex)
			}
		}
		.padding()
		.background(Color("BackgroundColor"))
	}
	
	// Décale la phrase au départ pour qu'elle arrive soit de la gauche soit de la droite
	private func offsetFor(_ index: Int) -> CGFloat {
		if currentIndex < index {
			// Phrase pas encore affichée → hors écran
			return index % 2 == 0 ? -UIScreen.main.bounds.width : UIScreen.main.bounds.width
		} else {
			// Phrase déjà affichée → position normale
			return 0
		}
	}
}

#Preview {
	OnboardingView()
}
