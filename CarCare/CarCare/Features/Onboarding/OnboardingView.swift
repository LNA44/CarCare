//
//  OnboardingView.swift
//  CarCare
//
//  Created by Ordinateur elena on 20/09/2025.
//

import SwiftUI
import ConfettiSwiftUI

struct OnboardingView: View {
	@AppStorage("hasSeenOnboarding") private var hasSeenOnboarding = false
    @State private var confettiTrigger = 0
	@State private var currentIndex = 0
	@State private var showButton = false
	@State private var cyclingView = AnimationView(name: "Cycling")
	let questions = Constants.allQuestions
	
	var body: some View {
		ZStack {
			// Préchargement invisible pour éviter le lag
			cyclingView
				.frame(width: 20, height: 20)
				.opacity(0)
			
			VStack(spacing: 40) {
				VStack(spacing: 40) {
					ForEach(questions.indices, id: \.self) { index in
						VStack {
							Text(LocalizedStringKey(questions[index]))
								.font(currentIndex == index ? .system(size: 28, weight: .bold, design: .rounded) : .system(size: 18, weight: .bold, design: .rounded))
								.multilineTextAlignment(.center)
								.lineLimit(nil)               // ✅ permet plusieurs lignes
								.fixedSize(horizontal: false, vertical: true)
								.opacity(currentIndex >= index ? 1 : 0)
								.offset(x: offsetFor(index))
								.padding(.vertical, currentIndex == index ? 10 : 25)
								.animation(.easeInOut(duration: 0.8), value: currentIndex)
							
							
							if index == 0 && currentIndex > 0 {
								cyclingView
									.frame(width: 100, height: 100)
									.scaleEffect(currentIndex == index ? 1.2 : 0.6)
									.opacity(currentIndex >= index ? 1 : 0)
									.offset(x: offsetFor(index))
									.animation(.easeInOut(duration: 0.8), value: currentIndex)
							}
						}
					}
				}
				.frame(height:700)
				
                
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
						Text(LocalizedStringKey(
							currentIndex < questions.count - 1 ? ButtonConstants.next : ButtonConstants.start
						))
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
            ConfettiCannon(trigger: $confettiTrigger, num: 50, radius: 300)
        }
        .onAppear {
            // Déclenche les confettis pour la première phrase
            confettiTrigger += 1
        }
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
