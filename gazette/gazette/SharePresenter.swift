//
//  DetailPresenter.swift
//  gazette
//
//  Created by Alireza Ghias on 2/3/1396 AP.
//  Copyright © 1396 AreaTak. All rights reserved.
//

import UIKit
import QRCode
class SharePresenter: PresenterProtocol {
	let vc: ViewProtocol
	var entity: Transaction!
	required init(_ vc: ViewProtocol) {
		self.vc = vc
	}
	func qrCode() -> UIImage? {
		let code = QRCode(link())
		return code!.image
	}
	func link() -> String {
		return "http://sabtshod.com/#/transaction/detail/" + entity.transactionId
	}
	func transactionId() -> String {
		return entity.transactionId
	}
	func timeStamp() -> String {
		if entity.transactionDate != nil {
			return DateUtil.toPersian(entity.transactionDate!)
		} else {
			return ""
		}
	}
}
