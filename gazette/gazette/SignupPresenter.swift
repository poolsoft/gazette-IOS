//
//  SignupPresenter.swift
//  gazette
//
//  Created by Alireza Ghias on 2/2/1396 AP.
//  Copyright © 1396 AreaTak. All rights reserved.
//

import Foundation
class SignupPresenter: PresenterProtocol {
	let vc: ViewProtocol
	private var transactions: [Transaction]?
	required init(_ vc: ViewProtocol) {
		self.vc = vc
	}
	func signup(_ username: String, _ password: String, _ onComplete: CallBack) {
		
	}
	func login(_ username: String, _ password: String, _ onComplete: CallBack) {
		
	}
}
