//
//  PaywallView.swift
//  CarCare
//
//  Created by Ordinateur elena on 14/09/2025.
//

import SwiftUI
import StoreKit

struct PaywallView: View {
	@Environment(\.presentationMode) var presentationMode
	@EnvironmentObject var subscriptionManager: SubscriptionManager
	@AppStorage("isDarkMode") private var isDarkMode = false
	@AppStorage("isPremiumUser") private var isPremiumUser = false
	@State private var selectedProduct: Product? = nil

	var body: some View {
		ZStack {
			Color.black.opacity(isDarkMode ? 0.6 : 0.2)
				.edgesIgnoringSafeArea(.all)
			
			VStack(spacing: 20) {
				VStack(spacing: 15) {
					// MARK: - Title
					Text(NSLocalizedString("paywall_title", comment: ""))
						.font(.system(size: 28, weight: .bold, design: .rounded))
						.foregroundColor(isDarkMode ? .white : .black)
						.multilineTextAlignment(.center)
					
					// MARK: - Description
					Text(NSLocalizedString("paywall_description", comment: ""))
						.font(.system(size: 16, weight: .medium, design: .rounded))
						.foregroundColor(isDarkMode ? Color.white.opacity(0.85) : Color.black.opacity(0.7))
						.multilineTextAlignment(.center)
						.padding(.horizontal, 20)
					
					// MARK: - Icon
					Image(systemName: "lock.shield")
						.resizable()
						.scaledToFit()
						.frame(width: 100, height: 100)
						.foregroundColor(Color("AppPrimaryColor"))
						.padding(.vertical, 10)
					
					// MARK: - Subscription Options
					VStack(spacing: 12) {
						ForEach(subscriptionManager.products.sorted(by: { $0.id > $1.id }), id: \.id) { product in
							let info = titleAndPrice(for: product)
							
							SubscriptionButton(
								title: info.title,
								price: info.price,
								isSelected: selectedProduct?.id == product.id
							) {
								selectedProduct = product
							}
						}
					}
					.padding(.vertical, 5)
					
					// MARK: - Upgrade Button
					Button(action: {
						guard let product = selectedProduct else { return }
						print("selected product: \(product)")
						Task {
							do {
								let result = try await product.purchase()
								switch result {
								case .success(let verification):
									switch verification {
									case .verified(let transaction):
										// Transaction valide -> finish
										await transaction.finish()
										isPremiumUser = true
										presentationMode.wrappedValue.dismiss()
										print("Achat réussi : \(transaction.productID)")
									case .unverified(_, _):
										print("Transaction non vérifiée")
									}
								case .userCancelled:
									print("Utilisateur a annulé l'achat")
								case .pending:
									print("Transaction en attente")
								@unknown default:
									print("État inconnu")
								}
							} catch {
								print("Erreur achat : \(error.localizedDescription)")
							}
						}
					}) {
						Text(NSLocalizedString("paywall_button_upgrade", comment: ""))
							.font(.system(size: 18, weight: .bold, design: .rounded))
							.lineLimit(1)
							.minimumScaleFactor(0.8)
							.frame(maxWidth: .infinity, minHeight: 50)
							.foregroundColor(.white)
							.background(Color("AppPrimaryColor"))
							.cornerRadius(12)
							.shadow(color: .black.opacity(0.25), radius: 5, x: 0, y: 3)
					}
					.padding(.horizontal, 20)
					
					// MARK: - Restore Purchases
					Button(action: {
						Task {
							await subscriptionManager.restorePurchases()
						}
					}) {
						Text(NSLocalizedString("paywall_button_restore", comment: ""))
							.font(.system(size: 16, weight: .medium, design: .rounded))
							.lineLimit(1)
							.minimumScaleFactor(0.8)
							.frame(maxWidth: .infinity, minHeight: 44)
							.foregroundColor(isDarkMode ? .white : .black)
							.background(isDarkMode ? Color.white.opacity(0.1) : Color.black.opacity(0.05))
							.cornerRadius(12)
					}
					.padding(.horizontal, 20)
					
					// MARK: - Cancel Button
					Button(action: {
						presentationMode.wrappedValue.dismiss()
					}) {
						Text(NSLocalizedString("paywall_button_cancel", comment: ""))
							.font(.system(size: 16, weight: .medium, design: .rounded))
							.lineLimit(1)
							.minimumScaleFactor(0.8)
							.frame(maxWidth: .infinity, minHeight: 44)
							.foregroundColor(isDarkMode ? .white : .black)
							.background(isDarkMode ? Color.white.opacity(0.1) : Color.black.opacity(0.05))
							.cornerRadius(12)
					}
					.padding(.horizontal, 20)
					.padding(.bottom, 15)
				}
				.padding()
				.background(
					Group {
						if #available(iOS 17, *) {
							// Liquid Glass sur iOS 17+
							Rectangle()
								.fill(.regularMaterial)
						} else {
							// Fallback pour iOS 16 et antérieur
							Rectangle()
								.fill(Color("BackgroundColor")) // couleur opaque
						}
					}
				)
				.cornerRadius(20)
				.shadow(color: .black.opacity(isDarkMode ? 0.2 : 0.3), radius: 10, x: 0, y: 5)
				.padding(.horizontal, 20)
			}
		}
	}
}

extension PaywallView {
	func titleAndPrice(for product: Product) -> (title: String, price: String) {
		switch product.id {
		case "premium_weekly":
			return (NSLocalizedString("paywall_weekly", comment: ""), NSLocalizedString("paywall_price_weekly", comment: ""))
		case "Premium_annual":
			return (NSLocalizedString("paywall_yearly", comment: ""), NSLocalizedString("paywall_price_yearly", comment: ""))
		default:
			return (product.displayName, product.displayPrice)
		}
	}
}


#Preview {
    PaywallView()
}
