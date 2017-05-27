//
//  Transaction.swift
//  gazette
//
//  Created by Alireza Ghias on 2/2/1396 AP.
//  Copyright © 1396 AreaTak. All rights reserved.
//

import Foundation
class Transaction: BaseEntity {
	dynamic var transactionId: String = ""
	dynamic var desc: String = ""
	dynamic var transactionDate: Date? = nil
	dynamic var transactionConfirmDate: Date? = nil
	dynamic var fileId: String = ""
	dynamic var fileAddress: String = ""
	dynamic var status: Int = 0 // 0 -> Pending, 1 -> Confirmed
	
	func update(_ map: [String: Any]) {
		self.transactionId = map["txId"] as? String ?? ""
		self.desc = map["desc"] as? String ?? ""
		if let date = map["txCreatedDate"] as? Double {
			self.transactionDate = Date(timeIntervalSince1970: date/1000.0)
		}
		if let date = map["txConfirmDate"] as? Double {
			self.transactionConfirmDate = Date(timeIntervalSince1970: date/1000.0)
		}
		self.fileId = map["fileId"] as? String ?? ""
		self.status = map["confirmations"] as? Int ?? 0
	}
	
}
