//
//  SubscriptionManager.swift
//  CarCare
//
//  Created by Ordinateur elena on 15/09/2025.
//

import Foundation
import StoreKit
import SwiftUI

@MainActor
final class SubscriptionManager: ObservableObject {
	static let shared = SubscriptionManager()

	// produits récupérés depuis App Store
	@Published var products: [Product] = []

	// état de l'utilisateur
	@Published var isPremium: Bool = UserDefaults.standard.bool(forKey: "isPremiumUser")
	@Published var isLoadingProducts = false
	@Published var purchaseInProgress = false
	@Published var lastError: Error?

	private var updateTask: Task<Void, Never>? = nil

	private init() {
		// Start listening transaction updates (purchases, restores, renewals)
		listenForTransactions()
		// Load products & current entitlements on init
		Task {
			await loadProducts()
			await checkCurrentEntitlements()
		}
	}

	// MARK: - Load products
	private let productIDs = ["premium_weekly", "Premium_annual"]

	func loadProducts() async {
		isLoadingProducts = true
		defer { isLoadingProducts = false }
		do {
			let storeProducts = try await Product.products(for: productIDs)
			products = storeProducts
		} catch {
			lastError = error
			print("⛔️ loadProducts error: \(error)")
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
				// verification is VerificationResult<Transaction>
				switch verification {
				case .verified(let transaction):
					// Purchase verified by StoreKit
					await handlePurchased(transaction)
					return true
				case .unverified(_, let verificationError):
					// Transaction not verified - don't unlock content
					print("⚠️ Unverified transaction: \(verificationError.localizedDescription)")
					lastError = verificationError
					return false
				}
			case .userCancelled:
				print("User cancelled")
				return false
			case .pending:
				print("Purchase pending")
				return false
			@unknown default:
				return false
			}
		} catch {
			lastError = error
			print("⛔️ purchase error: \(error)")
			return false
		}
	}

	private func handlePurchased(_ transaction: StoreKit.Transaction) async {
		// Mark product as owned
		purchased(productID: transaction.productID)
		// Complete the transaction
		await transaction.finish()
	}

	private func purchased(productID: String) {
		// simple policy: any known premium product -> premium
		UserDefaults.standard.set(true, forKey: "isPremiumUser")
		isPremium = true
	}

	// MARK: - Restore / check entitlements
	/// Interroger les entitlements actuellement valides (use for restore)
	func checkCurrentEntitlements() async {
		var foundAny = false
			for await verificationResult in Transaction.currentEntitlements {
				switch verificationResult {
				case .verified(let transaction):
					// transaction.productID is an active entitlement
					print("Entitled to: \(transaction.productID)")
					foundAny = true
					// optional: store which product user has
					UserDefaults.standard.set(true, forKey: "isPremiumUser")
				case .unverified(_, _):
					// ignore unverified
					break
				}
			}

		DispatchQueue.main.async {
			self.isPremium = foundAny
			UserDefaults.standard.set(foundAny, forKey: "isPremiumUser") // met à jour la valeur persistée
		}
	}

	// MARK: - Listen transaction updates (renewals, purchases that happen outside app)
	private func listenForTransactions() {
		// Cancel existing task if any
		updateTask?.cancel()
		updateTask = Task.detached { [weak self] in
			for await verificationResult in Transaction.updates {
				// each verificationResult is VerificationResult<Transaction>
				if Task.isCancelled { break }
				switch verificationResult {
				case .verified(let transaction):
					// handle verified transaction (renewal/purchase)
					await self?.handleTransactionUpdate(transaction)
				case .unverified(_, let error):
					print("⚠️ update unverified transaction: \(error.localizedDescription)")
				}
			}
		}
	}

	private func handleTransactionUpdate(_ transaction: StoreKit.Transaction) async {
		// Update local entitlement state if necessary
		print("Transaction update: \(transaction.productID)")
		// Example: if it's a premium product, mark premium and finish
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
