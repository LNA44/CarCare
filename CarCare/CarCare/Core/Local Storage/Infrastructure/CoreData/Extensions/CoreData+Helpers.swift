//
//  CoreData+Helpers.swift
//  CarCare
//
//  Created by Ordinateur elena on 15/07/2025.
//

import CoreData
extension NSPersistentContainer {
	static func load(name: String, model: NSManagedObjectModel, url: URL) throws -> NSPersistentContainer {
		let description = NSPersistentStoreDescription(url: url)
		let container = NSPersistentContainer(name: name, managedObjectModel: model)
		container.persistentStoreDescriptions = [description]
		
		var loadError: Swift.Error?
		container.loadPersistentStores { loadError = $1 } //(storeDerscription, error) -> loadError = error
		try loadError.map { throw $0 } //si error = nil on sort sinon on continue
		
		return container
	}
}

extension NSManagedObjectModel {
	static func with(name: String, in bundle: Bundle) -> NSManagedObjectModel? {
		return bundle
			.url(forResource: name, withExtension: "momd")
			.flatMap { NSManagedObjectModel(contentsOf: $0) } //initialise un NSManagedObjectModel à partir de l'URL
	}
}
