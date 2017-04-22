//
//  TransactionManager.swift
//  gazette
//
//  Created by Alireza Ghias on 2/2/1396 AP.
//  Copyright © 1396 AreaTak. All rights reserved.
//

import Foundation


class HomePresenter: PresenterProtocol {
	
	let vc: ViewProtocol
	private var transactions: [Transaction]?
	required init(_ vc: ViewProtocol) {
		self.vc = vc
	}
	
	func listAllTransactions() -> [Transaction] {
		if transactions == nil {
			transactions = [Transaction("1", Date(), 0), Transaction("2", Date(), 0), Transaction("3", Date(), 0), Transaction("4", Date(), 0), Transaction("5", Date(), 0)]
		}
		return transactions!
	}
	
	func searchTransaction(_ query: String) {
		if query.isEmpty {
			transactions = nil
			listAllTransactions()
			return
		}
		transactions = [Transaction("10", Date(), 0), Transaction("20", Date(), 0), Transaction("30", Date(), 0), Transaction("40", Date(), 0), Transaction("50", Date(), 0)]		
	}
}
