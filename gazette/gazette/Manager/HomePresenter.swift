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
	let transactionDao = TransactionDao()
	var transactions: [Transaction]?
	required init(_ vc: ViewProtocol) {
		self.vc = vc
	}
	
	func requestTransactions() {
		requestLocalTransactions()
		if IOSUtil.lock("requestTransaction") {
			RestHelper.request(.post, json: false, command: "listUserTransactions", params: ["token":CurrentUser.token], onComplete: { (data) in
				IOSUtil.unLock("requestTransaction")
				let map = data as! [String: [String: Any]]
				for entity in map {
					if let transaction = self.transactionDao.findByTxId(entity.key) {
						self.transactionDao.save({ () -> Transaction in
							transaction.update(entity.value)
							return transaction
						})
					} else {
						self.transactionDao.save({ () -> Transaction in
							let transaction = Transaction()
							transaction.update(entity.value)
							return transaction
						})
					}
				}
				IOSUtil.postDelay({
					self.requestLocalTransactions()
					self.vc.reload?()
				}, seconds: 0)
			}) { (error, data) in
				IOSUtil.unLock("requestTransaction")
			}
		}
	}
	func requestLocalTransactions() {
		transactions = transactionDao.findAll().map({ (transaction) -> Transaction in
			return transaction
		})
	}
	
	func searchTransaction(_ query: String) {
		if query.isEmpty {
			requestLocalTransactions()
		} else {
			transactions = transactionDao.search(query).map({ (transaction) -> Transaction in
				return transaction
			})
		}
	}
}
