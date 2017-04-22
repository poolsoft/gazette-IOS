//
//  Dao.swift
//  app
//
//  Created by alireza ghias on 6/30/16.
//  Copyright © 2016 iccima. All rights reserved.
//

import Foundation
import RealmSwift
import KeychainSwift
class Dao<T: BaseEntity> {
	
	static func setup() {
		let config = Realm.Configuration(
			schemaVersion: 1,
			migrationBlock: { migration, oldSchemaVersion in
//				migration.deleteData(forType: "BaseEntity")

				// We haven’t migrated anything yet, so oldSchemaVersion == 0
				if (oldSchemaVersion < 1) {
					// Nothing to do!
					// Realm will automatically detect new properties and removed properties
					// And will update the schema on disk automatically
				}
		})
		Realm.Configuration.defaultConfiguration = config
	}
	
	func save(_ updateFunc: @escaping (Void) -> T) {
		do{
			let realm = try Realm()
			realm.beginWrite()
			let entity = try updateFunc()
			entity._modified = Date()
			if entity.id == nil {
				entity.id = NSUUID().uuidString
				entity._created = Date()
				realm.add(entity, update: true)
			} else {
				realm.add(entity, update: true)
			}
			try realm.commitWrite()
			
		}catch let error as NSError{
			NSLog("cant write to realm %@", error.domain)
		}
	}
	
	func findById(_ id: String) -> T? {
		let realm = try! Realm()
		if id.isEmpty {
			return nil
		}
		return realm.object(ofType: T.self, forPrimaryKey: id as AnyObject)
	}
	
	func findAll() -> Results<T> {
		let realm = try! Realm()
		return realm.objects(T.self)
	}
	func delete(_ entity: T) {
		do {
			let realm = try Realm()
			realm.beginWrite()
			realm.delete(entity)
			try realm.commitWrite()
			
		} catch {
			print("delete failed")
		}
	}
	
	func deleteAll() -> Bool {
		do {
			let realm = try Realm()
			realm.beginWrite()
			let all = realm.objects(T.self)
			realm.delete(all)
			try realm.commitWrite()
			return true
		} catch {
			print("delete failed")
			return false
		}
	}
	func refresh() -> Bool {
		do {
			let realm = try Realm()
			return realm.refresh()
		} catch {
			print("refresh failed")
			return false
		}
	}
}
