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
	func signup(_ username: String, _ password: String, _ confirmPassword: String, _ onComplete: @escaping CallBack, _ onError: @escaping ErrorCallBack) {
		RestHelper.request(.post, json: false, command: "signup", params: ["email":username, "passwordHash":CryptoUtil.sha1(password), "confirmPasswordHash":CryptoUtil.sha1(confirmPassword), "platform": "Ios"], onComplete: { (data) in
			let userInfo = data as! [String: Any]
			CurrentUser.token = userInfo["token"] as? String ?? ""
			CurrentUser.username = userInfo["email"] as? String ?? ""
			CurrentUser.name = userInfo["name"] as? String ?? ""
			CurrentUser.lastname = userInfo["lastName"] as? String ?? ""
			CurrentUser.picId = userInfo["picId"] as? String ?? ""
			CurrentUser.passwordHash = userInfo["passwordHash"] as? String ?? ""
			CurrentUser.credit = userInfo["credit"] as? Double ?? 0
			onComplete(data)
		}) { (error, data) in
			onError(error, data)
		}
	}
	func login(_ username: String, _ password: String, _ onComplete: @escaping CallBack, _ onError: @escaping ErrorCallBack) {
		RestHelper.request(.post, json: false, command: "login", params: ["email":username, "passwordHash":CryptoUtil.sha1(password), "platform":"Ios"], onComplete: { (data) in
			let userInfo = data as! [String: Any]
			CurrentUser.token = userInfo["token"] as? String ?? ""
			CurrentUser.username = userInfo["email"] as? String ?? ""
			CurrentUser.name = userInfo["name"] as? String ?? ""
			CurrentUser.lastname = userInfo["lastName"] as? String ?? ""
			CurrentUser.picId = userInfo["picId"] as? String ?? ""
			CurrentUser.passwordHash = userInfo["passwordHash"] as? String ?? ""
			CurrentUser.credit = userInfo["credit"] as? Double ?? 0
			onComplete(data)
		}) { (error, data) in
			onError(error, data)
		}
	}
}
