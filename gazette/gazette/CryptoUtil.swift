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
}
