//
//  StringUtil.swift
//  app
//
//  Created by alireza ghias on 8/9/16.
//  Copyright © 2016 iccima. All rights reserved.
//

import UIKit
class StringUtil {
	static let noPhoto = UIImage(named: "No_Photo")!.resizedImageWithSize(CGSize(width: 30, height: 30))
	static var uiimageList: [UIImage] = {
		var images = [UIImage]()
		for color in colorList {
			images.append(IOSUtil.setColorFilter(noPhoto, color: color).rounded)
		}
		return images
	}()
	static let colorList = [UIColor(netHexWithAlpha: 0x462ecc71), UIColor(netHexWithAlpha: 0x463498db), UIColor(netHexWithAlpha: 0x469b59b6), UIColor(netHexWithAlpha: 0x4634495e), UIColor(netHexWithAlpha: 0x46e74c3c), UIColor(netHexWithAlpha: 0x46f1c40f)]
	static func getInitials(_ fullName: String?) -> String {
		guard fullName != nil else {
			return ""
		}
		
		if fullName!.isEmpty {
			return "";
		}
		let parts = fullName!.split(" ");
		var returnValue = "";
		for part in parts {
			if part.characters.count > 0 {
				returnValue += part.substring(to: part.characters.index(part.startIndex, offsetBy: 1)) + "‌"
			}
		}
		if returnValue.characters.count > 2 {
			returnValue = returnValue.substring(to: returnValue.characters.index(returnValue.startIndex, offsetBy: 2))
		}
		return returnValue;
	}
	
	static func getColor(_ name: String?) -> UIColor {
		if name != nil && !name!.isEmpty {
			var randomColorIndicator = 0
			for c in name!.characters {
				randomColorIndicator += c.unicodeScalarCodePoint()
			}
			
			let index = randomColorIndicator % colorList.count
			return colorList[index]
		}
		return UIColor(netHexWithAlpha: 0x462ecc71)
	}
	static func getUIImage(_ name: String?) -> UIImage {
		if name != nil && !name!.isEmpty {
			var randomColorIndicator = 0
			for c in name!.characters {
				randomColorIndicator += c.unicodeScalarCodePoint()
			}
			
			let index = randomColorIndicator % colorList.count
			return uiimageList[index]
		}
		return IOSUtil.setColorFilter(noPhoto, color: UIColor(netHexWithAlpha: 0x462ecc71)).rounded
	}
	static func intShortener(_ count: Int) -> String {
		if count < 1000 {
			return String(count)
		} else if count < 1000000 {
			let n = count / 1000
			return String(n) + "K"
		} else if count < 1000000000 {
			let n = count / 1000000
			return String(n) + "M"
		} else {
			return "+G"
		}
	}
	static func fixPersianNumbers(_ text: String?) -> String {
		if (text == nil) {
			return ""
		} else {
			var result = text!.replace("\u{0660}", withString: "0").replace("\u{0661}", withString: "1").replace("\u{0662}", withString: "2").replace("\u{0663}", withString: "3").replace("\u{0664}", withString: "4").replace("\u{0665}", withString: "5").replace("\u{0666}", withString: "6").replace("\u{0667}", withString: "7").replace("\u{0668}", withString: "8").replace("\u{0669}", withString: "9")
			result = result.replace("\u{06F0}", withString: "0").replace("\u{06F1}", withString: "1").replace("\u{06F2}", withString: "2").replace("\u{06F3}", withString: "3").replace("\u{06F4}", withString: "4").replace("\u{06F5}", withString: "5").replace("\u{06F6}", withString: "6").replace("\u{06F7}", withString: "7").replace("\u{06F8}", withString: "8").replace("\u{06F9}", withString: "9")
			
			return result
		}
	}
	static func persianFix(_ text: String?) -> String {
		if (text == nil) {
			return ""
		} else {
			let result = fixPersianNumbers(text).replace("\u{06AA}", withString: "ک").replace("\u{0643}", withString: "ک").replace("\u{0649}", withString: "ی").replace("\u{064A}", withString: "ی")
			return result
		}
	}
	
	static func addSeparator(_ amount: NSNumber) -> String {
		return addSeparator(String(format: "%.0f", amount.doubleValue))
	}
	static func addSeparator(_ s: String) -> String {
		do {
			var retStr = ""
			let regEx = try NSRegularExpression(pattern: "[^0-9]+", options: .caseInsensitive)
			
			let modStr = regEx.stringByReplacingMatches(in: s, options: [], range: NSMakeRange(0, s.length), withTemplate: "")
			for i in 0..<modStr.length {
				retStr += modStr.substring(i, i + 1)
				if ((modStr.length - 1) - i) % 3 == 0 && ((modStr.length - 1) - i) != 0 {
					retStr += ","
				}
			}
			return retStr
		} catch {
			print("Error in addSeparator for String " + (s ?? ""))
			return ""
		}
	}
	
	static func formatCard(_ card: String) -> String {
		if card.length != 16 {
			// Invalid card length
			return card
		}
		return String(format: "\u{202A}%@-%@-%@-%@", card.substring(0, 4), card.substring(4, 8), card.substring(8, 12), card.substring(12, 16))
	}
	
	static func toNumberAndStarOnlyString(_ s: String) -> String {
		do {
			let regEx = try NSRegularExpression(pattern: "[^0-9*]+", options: .caseInsensitive)
			return regEx.stringByReplacingMatches(in: s, options: [], range: NSMakeRange(0, s.length), withTemplate: "")
		} catch {
			print("Error in addSeparator for toNumberAndStarOnlyString " + s)
			return ""
		}
	}
	
	static func toNumberOnlyString(_ s: String) -> String {
		do {
			let regEx = try NSRegularExpression(pattern: "[^0-9]+", options: .caseInsensitive)
			return regEx.stringByReplacingMatches(in: s, options: [], range: NSMakeRange(0, s.length), withTemplate: "")
		} catch {
			print("Error in addSeparator for toNumberAndStarOnlyString " + s)
			return ""
		}
	}
	
	static func hideMessage(_ message: String, leadingVisibleCharsCount: Int, trailingVisibleCharsCount: Int) -> String {
		
		if message.length <= leadingVisibleCharsCount + trailingVisibleCharsCount {
			return message
		}
		
		let lead = message.substring(0, leadingVisibleCharsCount)
		let trail = message.substring(message.length - trailingVisibleCharsCount)
		var stars = ""
		for _ in 0..<message.length - (leadingVisibleCharsCount + trailingVisibleCharsCount) {
			stars += "*"
		}
		return lead + stars + trail
	}
	
	static func hideDeposit(_ depositNo: String) -> String {
		return hideMessage(depositNo, leadingVisibleCharsCount: 6, trailingVisibleCharsCount: 3)
	}
	
	static func hideAndFormatCard(_ cardNo: String) -> String {
		let unformatted = toNumberAndStarOnlyString(cardNo)
		return formatCard(hideMessage(unformatted, leadingVisibleCharsCount: 6, trailingVisibleCharsCount: 3))
	}
	
	static func decideWhatToShow(_ name: String, lastName: String, phoneNo: String) -> String {
		if(!name.isEmpty || !lastName.isEmpty) {
			return name.capitalized + " " + lastName.capitalized
		} else {
			return phoneNo;
		}
	}
	static func separateFormat(_ plain: String, separators: [Int], delimiter: String) -> String {
		var strings = Array<String?>(repeating: nil, count: separators.count)
		for i in 0..<separators.count {
			var prev = 0;
			for j in 0..<i {
				prev += separators[j];
			}
			let end = separators[i] + prev;
			if (plain.length >= end) {
				strings[i] = plain.substring(prev, end);
			} else if (plain.length >= prev) {
				strings[i] = plain.substring(prev);
			}
		}
		var sb = ""
		for i in 0..<separators.count {
			if (strings[i] != nil) {
				if (!strings[i]!.isEmpty) {
					sb.append(strings[i]!);
				}
				if (strings[i]!.length == separators[i] && i < separators.count - 1) {
					sb.append(delimiter);
				}
			}
		}
		return sb
	}
	
}
