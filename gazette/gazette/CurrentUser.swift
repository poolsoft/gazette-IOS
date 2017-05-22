//
//  CurrentUser.swift
//  gazette
//
//  Created by Alireza Ghias on 2/2/1396 AP.
//  Copyright © 1396 AreaTak. All rights reserved.
//

import Foundation
import KeychainSwift
class CurrentUser: NSObject {
	static let keychain = KeychainSwift()
	static var token: String {
		get {
			return keychain.get("token") ?? ""
		}
		set {
			keychain.set(newValue, forKey: "token")
		}
	}
	static var username: String {
		get {
			return keychain.get("username") ?? ""
		}
		set {
			keychain.set(newValue, forKey: "username")
		}
	}
	static var name: String {
		get {
			return keychain.get("name") ?? ""
		}
		set {
			keychain.set(newValue, forKey: "name")
		}
	}
	static var passwordHash: String {
		get {
			return keychain.get("passwordHash") ?? ""
		}
		set {
			keychain.set(newValue, forKey: "passwordHash")
		}
	}
	
	static var lastname: String {
		get {
			return keychain.get("lastname") ?? ""
		}
		set {
			keychain.set(newValue, forKey: "lastname")
		}
	}
	static var picId: String {
		get {
			return keychain.get("picId") ?? ""
		}
		set {
			keychain.set(newValue, forKey: "picId")
		}
	}
	static var cidToken: String {
		get {
			return keychain.get("cidToken") ?? ""
		}
		set {
			keychain.set(newValue, forKey: "cidToken")
		}
	}
	static var cidUploaded: String {
		get {
			return keychain.get("cidUploaded") ?? ""
		}
		set {
			keychain.set(newValue, forKey: "cidUploaded")
		}
	}
	static var credit: Double {
		get {
			var tmp: Double = 0
			(keychain.getData("credit") as NSData?)?.getBytes(&tmp, length: MemoryLayout.size(ofValue: tmp))
			return tmp
		}
		set {
			var value = newValue
			let data = withUnsafePointer(to: &value) {
				Data(bytes: UnsafePointer($0), count: MemoryLayout.size(ofValue: newValue))
			}
			keychain.set(data, forKey: "credit")
		}
	}
	static func update(_ userInfo: [String: Any], changeToken: Bool = true) {
		if changeToken {
			CurrentUser.token = userInfo["token"] as? String ?? ""
		}
		CurrentUser.username = userInfo["email"] as? String ?? ""
		CurrentUser.name = userInfo["name"] as? String ?? ""
		CurrentUser.lastname = userInfo["lastName"] as? String ?? ""
		CurrentUser.picId = userInfo["picId"] as? String ?? ""
		CurrentUser.passwordHash = userInfo["passwordHash"] as? String ?? ""
		CurrentUser.credit = userInfo["credit"] as? Double ?? 0
	}
	
}
