//
//  Constants.swift
//  app
//
//  Created by Ehsan on 7/9/16.
//  Copyright © 2016 iccima. All rights reserved.
//

import UIKit
class Constants: NSObject {		
	
	static let STUB = false
	static let SERVER_ADDRESS = "http://192.168.1.17:8080/"
	static let useSSL = false
	
}

struct ColorPalette {
	static let ChatBackground = UIColor(netHex: 0xF5F5F5)
	static let Actionbar = Primary
	static let Primary = UIColor(netHex: 0xF44336)
	static let DarkPrimary = UIColor(netHex: 0xD32F2F)
	static let SuperDarkPrimary = UIColor(netHex: 0xB71C1C)
	static let LightPrimary = UIColor(netHex: 0xEF5350)
	static let TextPrimary = UIColor(netHex: 0xFFFFFF)
	static let TextSecondary = UIColor(hexString: "#DD000000")
	static let TextGray = UIColor(netHex: 0xA0A0A0)
	static let Accent = UIColor(netHex: 0xFF1744)
	static let DarkAccent = UIColor(netHex: 0xD50000)
	static let Control = UIColor(netHex: 0x31000000)
	static let Background = UIColor(netHex: 0xFFFFFF)
	static let Divider = UIColor(netHex: 0x11000000)
	static let Neutral = UIColor(netHex: 0x4EA9C9)
	static let DarkNeutral = UIColor(netHex: 0x03A9F4)
	static let Success = UIColor(hexString: "#DD33CC33")
	static let Error = UIColor(hexString: "#DDF44336")
	
}
struct Dimensions {
	static let TextMedium = CGFloat(24)
	static let TextLarge = CGFloat(28)
	static let TextSmall = CGFloat(20)
	static let TextTiny = CGFloat(16)
	static let TextVeryTiny = CGFloat(12)
}
class AppFont {
	static let fontName = "Gandom"
	static func withSize(_ size: CGFloat) -> UIFont {
		return UIFont(name: fontName, size: size)!
	}
	
	static func font() -> UIFont {
		return UIFont(name: "Gandom", size: Dimensions.TextMedium)!
	}
}

