//
//  PhoneUtil.swift
//  app
//
//  Created by alireza ghias on 7/10/16.
//  Copyright © 2016 iccima. All rights reserved.
//

import Foundation
class PhoneUtil {
	static func toPlain(_ phone: String) -> String {
		return phone.replacingOccurrences(of: "+98", with: "0").replacingOccurrences(of: "+", with: "00").replacingOccurrences(of: " ", with: "").replacingOccurrences(of: "-", with: "").replacingOccurrences(of: "_", with: "").replacingOccurrences(of: "(", with: "").replacingOccurrences(of: ")", with: "")
	}
	static func toHide(_ phone: String) -> String {
		if phone.length > 7 {
			return "\u{200E}" + phone.substring(0, 7) + "****" + "\u{200E}";
		} else {
			return phone
		}
	}
}
