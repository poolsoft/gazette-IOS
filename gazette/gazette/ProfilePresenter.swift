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
	func myPicUrl() -> URL? {
		return URL(string: "https://avatars1.githubusercontent.com/u/10295952?v=3&s=400")
	}
	func editProfile(name: String, lastname: String, passwordHash: String, onComplete: @escaping CallBack, onError: @escaping ErrorCallBack) {
		if IOSUtil.lock("updateProfile") {
			RestHelper.request(.post, json: false, command: "updateProfile", params: ["token":CurrentUser.token, "passwordHash":passwordHash, "name":name, "lastName":lastname, "profilePic":""], onComplete: { (data) in
				IOSUtil.unLock("updateProfile")
				let userInfo = data as! [String: Any]
				CurrentUser.update(userInfo, changeToken: false)
				self.vc.reload?()
				onComplete(data)
			}, onError: { (error, data) in
				IOSUtil.unLock("updateProfile")
				onError(error, data)
			})
		}
		
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
	func requestUpdate() {
		if IOSUtil.lock("requestUpdateProfile") {
			RestHelper.request(.post, json: false, command: "getUser", params: ["token":CurrentUser.token], onComplete: { (data) in
				IOSUtil.unLock("requestUpdateProfile")
				let userInfo = data as! [String: Any]
				CurrentUser.update(userInfo, changeToken: false)
				self.vc.reload?()
			}, onError: { (error, data) in
				IOSUtil.unLock("requestUpdateProfile")
			})
		}
	}
	
}
