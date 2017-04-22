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
	dynamic var transactionDate: Date? = nil
	dynamic var status: Int = 0 // 0 -> Pending, 1 -> Confirmed
	convenience init(_ transactionId: String, _ transactionDate: Date, _ status: Int) {
		self.init()
		self.transactionId = transactionId
		self.transactionDate = transactionDate
		self.status = status
	}
	
}
