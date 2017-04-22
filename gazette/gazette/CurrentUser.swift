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
		return keychain.get("token") ?? ""
	}
	static var username: String {
		return keychain.get("username") ?? ""
	}
	static var credit: Double {
		var tmp: Double = 0
		(keychain.getData("credit") as NSData?)?.getBytes(&tmp, length: MemoryLayout.size(ofValue: Double.self))
		return tmp
	}
	
}
