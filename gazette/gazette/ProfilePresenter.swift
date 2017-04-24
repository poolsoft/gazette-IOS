//
//  ProfilePresenter.swift
//  gazette
//
//  Created by Alireza Ghias on 2/2/1396 AP.
//  Copyright © 1396 AreaTak. All rights reserved.
//

import Foundation
class ProfilePresenter: PresenterProtocol {
	let vc: ViewProtocol
	private var transactions: [Transaction]?
	required init(_ vc: ViewProtocol) {
		self.vc = vc
	}
	func myName() -> String {
		return CurrentUser.name
	}
	func myLastname() -> String {
		return CurrentUser.lastname
	}
	func myCredit() -> Double {
		return CurrentUser.credit
	}
	func myEmail() -> String {
		return CurrentUser.username
	}
	func myPicUrl() -> URL {
		return URL(fileURLWithPath: "http://google.com")
	}
	func editProfile(name: String, lastname: String, email: String) {
		
	}
	func logout() {
		CurrentUser.token = ""
		CurrentUser.name = ""
		CurrentUser.lastname = ""
		CurrentUser.username = ""
		CurrentUser.credit = 0
		CurrentUser.passwordHash = ""
		CurrentUser.picId = ""
	}
	
}
