//
//  SubscriptionManager.swift
//  CarCare
//
//  Created by Ordinateur elena on 15/09/2025.
//

/*import Foundation
import StoreKit
import SwiftUI

@MainActor
final class SubscriptionManager: ObservableObject {
	static let shared = SubscriptionManager()
	@Published var products: [Product] = []
	@Published var isPremium: Bool = UserDefaults.standard.bool(forKey: "isPremiumUser")
	@Published var isLoadingProducts = false
	@Published var purchaseInProgress = false
	@Published var lastError: Error?

	private var updateTask: Task<Void, Never>? = nil

	private init() {
		listenForTransactions()
		Task {
			await loadProducts()
			await checkCurrentEntitlements()
		}
	}

	// MARK: - Load products
	private let productIDs = ["Premium_weekly", "Premium_annual2"]

	func loadProducts() async {
		isLoadingProducts = true
		defer { isLoadingProducts = false }
		do {
			let storeProducts = try await Product.products(for: productIDs)
			products = storeProducts
		} catch {
			lastError = error
		}
	}

	// MARK: - Purchase
	func purchase(_ product: Product) async -> Bool {
		purchaseInProgress = true
		defer { purchaseInProgress = false }
		do {
			let result = try await product.purchase()
			switch result {
			case .success(let verification):
				switch verification {
				case .verified(let transaction):
					await handlePurchased(transaction)
					return true
				case .unverified(_, let verificationError):
					lastError = verificationError
					return false
				}
            case .userCancelled:
                lastError = NSError(domain: "Purchase", code: 1, userInfo: [NSLocalizedDescriptionKey: "The user canceled the purchase"])
                return false
            case .pending:
                lastError = NSError(domain: "Purchase", code: 2, userInfo: [NSLocalizedDescriptionKey: "Waiting for purchase"])
                return false
			@unknown default:
				return false
			}
		} catch {
			lastError = error
			return false
		}
	}

	private func handlePurchased(_ transaction: StoreKit.Transaction) async {
		purchased(productID: transaction.productID)
		await transaction.finish()
	}

	private func purchased(productID: String) {
		UserDefaults.standard.set(true, forKey: "isPremiumUser")
		isPremium = true
	}

	// MARK: - Restore / check entitlements
	func checkCurrentEntitlements() async {
		var foundAny = false
			for await verificationResult in Transaction.currentEntitlements {
				switch verificationResult {
				case .verified(let transaction):
					foundAny = true
					UserDefaults.standard.set(true, forKey: "isPremiumUser")
				case .unverified(_, _):
					break
				}
			}

		DispatchQueue.main.async {
			self.isPremium = foundAny
			UserDefaults.standard.set(foundAny, forKey: "isPremiumUser")
		}
	}

	// MARK: - Listen transaction updates (renewals, purchases that happen outside app)
    private func listenForTransactions() {
        updateTask?.cancel()
        updateTask = Task { [weak self] in
            guard let self = self else { return }
            
            for await verificationResult in Transaction.updates {
                if Task.isCancelled { break }
                
                switch verificationResult {
                case .verified(let transaction):
                    await self.handleTransactionUpdate(transaction)
                    
                case .unverified(_, let error):
                    self.lastError = NSError(
                        domain: "Purchase",
                        code: 1,
                        userInfo: [NSLocalizedDescriptionKey: "Erreur transaction non vérifiée : \(error.localizedDescription)"]
                    )
                @unknown default:
                    break
                }
            }
        }
    }

	private func handleTransactionUpdate(_ transaction: StoreKit.Transaction) async {
		UserDefaults.standard.set(true, forKey: "isPremiumUser")
		DispatchQueue.main.async {
			self.isPremium = true
		}
		await transaction.finish()
	}

	// MARK: - Public restore (callable from UI)
	func restorePurchases() async {
		await checkCurrentEntitlements()
	}
}
*/
