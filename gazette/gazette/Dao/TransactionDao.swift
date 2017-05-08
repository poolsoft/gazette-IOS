//
//  TransactionDao.swift
//  gazette
//
//  Created by Alireza Ghias on 2/2/1396 AP.
//  Copyright © 1396 AreaTak. All rights reserved.
//

import Foundation
import RealmSwift
class TransactionDao: Dao<Transaction> {
	func search(_ query: String) -> Results<Transaction> {
		let realm = try! Realm()
		let predicate = NSPredicate(format: "transactionId contains[c] %@ or desc contains[c] %@", query, query)
		return realm.objects(Transaction.self).filter(predicate).sorted(byKeyPath: "transactionDate", ascending: false)
	}
	func findByTxId(_ txId: String) -> Transaction? {
		let realm = try! Realm()
		let predicate = NSPredicate(format: "transactionId == %@", txId)
		return realm.objects(Transaction.self).filter(predicate).first
	}
}
