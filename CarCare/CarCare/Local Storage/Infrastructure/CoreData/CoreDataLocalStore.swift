//
//  CoreDataLocalStore.swift
//  CarCare
//
//  Created by Ordinateur elena on 15/07/2025.
//

import CoreData

final class CoreDataLocalStore {
	private static let modelName = "CarCare"
	private static let model = NSManagedObjectModel.with(name: modelName, in: Bundle(for: CoreDataLocalStore.self))
	
	private let container: NSPersistentContainer
	private let context: NSManagedObjectContext
	
	init(storeURL: URL) throws {
		guard let model = CoreDataLocalStore.model else {
			throw StoreError.modelNotFound
		}
		
		do {
			container = try NSPersistentContainer.load(name: CoreDataLocalStore.modelName, model: model, url: storeURL)
			context = container.newBackgroundContext() //toutes les opérations sont réalisées sur le background
		} catch {
			throw StoreError.failedToLoadPersistentContainer(error)
		}
	}
	
	func performSync<R>(_ action: (NSManagedObjectContext) -> Result<R, Error>) throws -> R { //nécessaire car on est sur background context
		let context = self.context
		var result: Result<R, Error>!
		context.performAndWait { result = action(context) }
		return try result.get()
	}
}

