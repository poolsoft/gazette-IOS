//
//  CryptoUtil.swift
//  gazette
//
//  Created by Alireza Ghias on 2/2/1396 AP.
//  Copyright © 1396 AreaTak. All rights reserved.
//

import Foundation
class CryptoUtil: NSObject {
	static func sha256(data : Data) -> Data {
		var hash = [UInt8](repeating: 0,  count: Int(CC_SHA256_DIGEST_LENGTH))
		data.withUnsafeBytes {
			_ = CC_SHA256($0, CC_LONG(data.count), &hash)
		}
		return Data(bytes: hash)
	}
	static func sha1(_ str: String) -> String {
		let data = str.data(using: String.Encoding.utf8)!
		var digest = [UInt8](repeating: 0, count:Int(CC_SHA1_DIGEST_LENGTH))
		data.withUnsafeBytes {
			_ = CC_SHA1($0, CC_LONG(data.count), &digest)
		}
		let hexBytes = digest.map { String(format: "%02hhx", $0) }
		return hexBytes.joined()
	}
}
