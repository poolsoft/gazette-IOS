//
//  IOSUtil.swift
//  app
//
//  Created by alireza ghias on 7/9/16.
//  Copyright © 2016 iccima. All rights reserved.
//

import UIKit
import ImageIO
import Photos
import MessageUI
class IOSUtil: NSObject {
	static let iosSemaphore = DispatchSemaphore(value: 0)
	static var lang = "Base" {
		didSet {
			UserDefaults.standard.setValue(lang, forKey: "selectedLanguage")
			UserDefaults.standard.synchronize()
		}
	}
	static let maxThumbnailPixel = CGFloat(50)
	static let lockQ = DispatchQueue(label: "serialQ", attributes: [])
	static let serialQ = DispatchQueue(label: "app_serialQ", attributes: [])
	static let backgroundQ: OperationQueue = {
		let q = OperationQueue()
		q.maxConcurrentOperationCount = 5
		return q
	}()
	static fileprivate var locks = Set<String>()
	// MARK: Functions
	static func snapshopOfCell(_ inputView: UIView) -> UIView {
		UIGraphicsBeginImageContextWithOptions(inputView.bounds.size, false, 0.0)
		inputView.layer.render(in: UIGraphicsGetCurrentContext()!)
		let image = UIGraphicsGetImageFromCurrentImageContext()! as UIImage
		UIGraphicsEndImageContext()
		let cellSnapshot : UIView = UIImageView(image: image)
		cellSnapshot.layer.masksToBounds = false
		cellSnapshot.layer.cornerRadius = 0.0
		cellSnapshot.layer.shadowOffset = CGSize(width: -5.0, height: 0.0)
		cellSnapshot.layer.shadowRadius = 5.0
		cellSnapshot.layer.shadowOpacity = 0.4
		return cellSnapshot
	}
	static func waitLock(_ name: String) -> Bool {
		while hasLock(name) {
			iosSemaphore.wait(timeout: dispatchTimeFromNow(30))
		}
		return lock(name)
	}
	static func lock(_ name: String) -> Bool {
		var result = false
		lockQ.sync {
			if locks.contains(name) {
				result = false
			} else {
				locks.insert(name)
				result = true
			}
		}
		return result
		
		
	}
	static func hasLock(_ name: String) -> Bool {
		return locks.contains(name)
	}
	static func unLock(_ name: String) {
		lockQ.sync {
			locks.remove(name)
			iosSemaphore.signal()
		}
	}
	static func dispatchTimeFromNow(_ seconds: Double) -> DispatchTime {
		return DispatchTime.now() + Double(Int64(seconds * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)
	}
	static func postDelay(_ block: @escaping () -> (), seconds: Double) {
		
		DispatchQueue.main.asyncAfter(deadline: dispatchTimeFromNow(seconds)) {
			block()
		}
		
		
	}
	static func postDelayInBackGroundThread(_ block: @escaping () -> (), seconds: Double) {
		postDelay({
			backgroundQ.addOperation({
				block()
			})
		}, seconds: seconds)
	}
	static func toVideoThumbnail(_ videoAsset: AVAsset) -> UIImage? {
		let imgGenerator = AVAssetImageGenerator(asset: videoAsset)
		do {
			let cgImage = try imgGenerator.copyCGImage(at: CMTimeMake(0, 1), actualTime: nil)
			return UIImage(cgImage: cgImage)
		} catch let error as NSError {
			print("could not create thumbnail \(error.domain)")
		}
		return nil
		
	}
	static func convertIntArrayToNSData(_ bytes: [Int]) -> Data {
		let data = bytes.map(){
			UInt8.init(bitPattern: Int8.init($0))
		}
		return Data(bytes: UnsafePointer<UInt8>(data), count: data.count)
	}
	static func toThumbnail(_ data: CFData, orientation: UIImageOrientation) -> UIImage? {
		if let imageSource = CGImageSourceCreateWithData(data, nil) {
			let options: [NSString: NSObject] = [
				kCGImageSourceThumbnailMaxPixelSize: maxThumbnailPixel as NSObject,
				kCGImageSourceCreateThumbnailFromImageAlways: true as NSObject
			]
			
			let scaledImage = CGImageSourceCreateThumbnailAtIndex(imageSource, 0, options as CFDictionary?).flatMap { UIImage(cgImage: $0, scale: 1.0, orientation: orientation) }
			return scaledImage
		}
		return nil
	}
	static func getCacheDirectory() -> String {
		return NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.cachesDirectory, .userDomainMask, true)[0]
	}
	static func getDirectory(_ directory: String) -> String {
		var path = getCacheDirectory()
		path = path + "/\(directory)"
		return path
	}
	static func getCache(_ directory: String, _ fileName: String, deleteIfExist: Bool = false) -> String {
		let fileManager = FileManager.default
		var path = getDirectory(directory)
		if !fileManager.fileExists(atPath: path) {
			try! fileManager.createDirectory(atPath: path, withIntermediateDirectories: true, attributes: nil)
		}
		path = path + "/\(fileName)"
		if fileManager.fileExists(atPath: path) {
			if deleteIfExist {
				IOSUtil.deleteFileIfExists(path)
				fileManager.createFile(atPath: path, contents: nil, attributes: nil)
			}
			return path
		} else {
			fileManager.createFile(atPath: path, contents: nil, attributes: nil)
			return path
		}
	}
	static func deleteFileIfExists(_ path: String) {
		if FileManager.default.fileExists(atPath: path) {
			try! FileManager.default.removeItem(atPath: path)
		}
	}
	static func getDocument(_ directory: String, _ fileName: String) -> String {
		var path = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, .userDomainMask, true)[0]
		let fileManager = FileManager.default
		path = path + "/\(directory)"
		if !fileManager.fileExists(atPath: path) {
			try! fileManager.createDirectory(atPath: path, withIntermediateDirectories: true, attributes: nil)
		}
		path = path + "/\(fileName)"
		if fileManager.fileExists(atPath: path) {
			return path
		} else {
			fileManager.createFile(atPath: path, contents: nil, attributes: nil)
			return path
		}
	}
	static func setColorFilter(_ image: UIImage, color: UIColor) -> UIImage
	{
		let ciImage = CIImage(image: image)
		let filter = CIFilter(name: "CIMultiplyCompositing")
		
		let colorFilter = CIFilter(name: "CIConstantColorGenerator")
		let ciColor = CIColor(color: color)
		colorFilter!.setValue(ciColor, forKey: kCIInputColorKey)
		let colorImage = colorFilter!.outputImage
		
		filter!.setValue(colorImage, forKey: kCIInputImageKey)
		filter!.setValue(ciImage, forKey: kCIInputBackgroundImageKey)
		if filter!.outputImage != nil {
			return UIImage(ciImage: filter!.outputImage!).resizedImageWithSize(image.size)
		} else {
			return image
		}
	}
	static func isValidNationalCode(_ code: String) -> Bool {
		if code.characters.count != 10 {
			return false
		}
		if code == "0000000000" || code == "1111111111" || code == "2222222222" ||
			code == "3333333333" || code == "4444444444" || code == "5555555555" ||
			code == "6666666666" || code == "7777777777" || code == "8888888888" ||
			code == "9999999999" {
			return false
		}
		
		var sum = 0
		let index = code.startIndex
		for i in 0..<9 {
			let c = code[i]
			sum += (Int(String(c)) ?? 0)! * (10 - i)
		}
		let remain = sum % 11
		var checkDigit = -1
		if remain < 2 {
			checkDigit = remain
		} else {
			checkDigit = 11 - remain
		}
		return Int(String(code.characters.last!) ?? "")! == checkDigit
	}
	static func isValidEmail(_ testStr:String) -> Bool {
		let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
		let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
		return emailTest.evaluate(with: testStr)
	}
	static func alert(_ what:String, controller: UIViewController) {
		alert(what, controller: controller, okHandler: nil)
	}
	static func alert(_ what:String, controller: UIViewController, okHandler: ((UIAlertAction) -> Void)?) {
		let alert = UIAlertController(title: "", message: what, preferredStyle: UIAlertControllerStyle.alert)
		alert.addAction(UIAlertAction(title: "تایید".localized, style: UIAlertActionStyle.default, handler: okHandler))
		IOSUtil.postDelay({
			controller.present(alert, animated: true, completion: nil)
		}, seconds: 0)
	}
	static func getUILable(view: UIView) -> UILabel? {
		for v in view.subviews {
			if v is UILabel {
				if !((v as! UILabel).text ?? "").isEmpty {
					return v as! UILabel
				}
				
			} else {
				return getUILable(view: v)
			}
		}
		return nil
	}
	
	static func alertInput(_ what: String, controller: UIViewController, link: NSURL? = nil, range: NSRange? = nil, linkTap: UITapGestureRecognizer? = nil, okHandler: ((UIAlertAction, UITextField) -> Void)?, onCancelHandler: ((UIAlertAction) -> Void)?) {
		let alert = UIAlertController(title: "", message: what, preferredStyle: UIAlertControllerStyle.alert)
		alert.addTextField { (textField) in
			textField.font = AppFont.withSize(Dimensions.TextSmall)
		}
		let paragraphStyle = NSMutableParagraphStyle()
		paragraphStyle.alignment = NSTextAlignment.right
		
		let messageText = NSMutableAttributedString(
			string: what,
			attributes: [
				NSParagraphStyleAttributeName: paragraphStyle,
				NSFontAttributeName : UIFont.preferredFont(forTextStyle: UIFontTextStyle.body),
				NSForegroundColorAttributeName : UIColor.black
			]
		)
		
		if link != nil && range != nil && linkTap != nil {
			messageText.addAttribute(NSLinkAttributeName, value: link!, range: range!)
			messageText.addAttribute(NSForegroundColorAttributeName, value: ColorPalette.Accent, range: range!)
			let label = getUILable(view: alert.view)
			label?.isUserInteractionEnabled = true
			label?.addGestureRecognizer(linkTap!)
			
		}
		
		
		alert.setValue(messageText, forKey: "attributedMessage")
		
		alert.addAction(UIAlertAction(title: "OK".localized, style: UIAlertActionStyle.default, handler: { (action) in
			okHandler?(action, alert.textFields![0])
		}))
		alert.addAction(UIAlertAction(title: "Cancel".localized, style: UIAlertActionStyle.default, handler: onCancelHandler))
		IOSUtil.postDelay({
			controller.present(alert, animated: true, completion: nil)
			
		}, seconds: 0)
	}
	static func alertTwoChoice(_ what: String, controller: UIViewController, positiveAction: String, negativeAction: String, positiveHandler: ((UIAlertAction) -> Void)?, negativeHandler: ((UIAlertAction) -> Void)?) {
		let alert = UIAlertController(title: "", message: what, preferredStyle: UIAlertControllerStyle.alert)
		alert.addAction(UIAlertAction(title: positiveAction, style: UIAlertActionStyle.default, handler: positiveHandler))
		alert.addAction(UIAlertAction(title: negativeAction, style: UIAlertActionStyle.default, handler: negativeHandler))
		controller.present(alert, animated: true, completion: nil)
	}
	static func getFolderSize(_ folderPath: String) -> Int { // Returns in Bytes
		var size = 0
		if let filesArray: [String] = FileManager.default.subpaths(atPath: folderPath) {
			for file in filesArray {
				let filePath = folderPath + "/\(file)"
				do {
					let fileDictionary:NSDictionary = try FileManager.default.attributesOfItem(atPath: filePath) as NSDictionary
					size += Int(fileDictionary.fileSize())
				} catch {
					
				}
			}
		}
		return size
	}
	static func clearCache() -> Bool {
		
		//try NSFileManager.defaultManager().removeItemAtPath(getCacheDirectory())
		
		let fileManager = FileManager.default
		let folderPath = getCacheDirectory()
		if let filesArray = fileManager.subpaths(atPath: folderPath) {
			for file in filesArray {
				let filePath = folderPath + "/\(file)"
				if fileManager.fileExists(atPath: filePath) {
					do {
						try fileManager.removeItem(atPath: filePath)
					} catch {
					}
				}
			}
		}
		
		return true
		
	}
	
	// MARK: label width calculations for forms
	
	static func calculateLabelWidth(_ label: UILabel) -> CGFloat {
		let labelSize = label.sizeThatFits(CGSize(width: CGFloat.greatestFiniteMagnitude, height: label.frame.height))
		return labelSize.width
	}
	
	static func calculateMaxLabelWidth(_ labels: [UILabel]) -> CGFloat {
		return labels.map(calculateLabelWidth).reduce(0, max)
	}
	
	static func updateWidthsForLabels(_ labels: [UILabel]) {
		let maxLabelWidth = calculateMaxLabelWidth(labels)
		for label in labels {
			let constraint = NSLayoutConstraint(item: label,
			                                    attribute: .width,
			                                    relatedBy: .equal,
			                                    toItem: nil,
			                                    attribute: .notAnAttribute,
			                                    multiplier: 1,
			                                    constant: maxLabelWidth)
			label.addConstraint(constraint)
		}
	}
	// MARK: SmsUtil
	static func sendSms(_ phone: String, message: String, delegate: MFMessageComposeViewControllerDelegate, vc: UIViewController) {
		if (MFMessageComposeViewController.canSendText()) {
			let controller = MFMessageComposeViewController()
			controller.body = message
			controller.recipients = [phone]
			controller.messageComposeDelegate = delegate
			vc.present(controller, animated: true, completion: nil)
		}
	}
	static func scaleImage(_ image: UIImage, maxWidth: CGFloat, maxHeight: CGFloat) -> UIImage {
		if (maxHeight > 0 && maxWidth > 0) {
			let width = image.size.width;
			let height = image.size.height;
			let ratio = max(maxHeight, maxWidth) / max(width, height);
			let finalWidth = width * ratio
			let finalHeight = height * ratio
			return image.resizedImageWithSize(CGSize(width: finalWidth, height: finalHeight))
			
		} else {
			return image;
		}
	}
	
	static func changeFont(_ view:UIView,font:UIFont) {
		for item in view.subviews {
			if item.isKind(of: UICollectionView.self) {
				let col = item as! UICollectionView
				for  row in col.subviews{
					changeFont(row, font: font)
				}
			}
			if item.isKind(of: UILabel.self) {
				let label = item as! UILabel
				label.font = font
			}else {
				changeFont(item, font: font)
			}
			
		}
	}
	static func createRowAction(_ width: CGFloat, height: CGFloat, title: String, image: UIImage, backgroundColor: UIColor, spaceCount: Int? = nil, handler: @escaping (UITableViewRowAction, IndexPath) -> Void) -> UITableViewRowAction {
		let font = AppFont.withSize(Dimensions.TextTiny)
		let whiteSpaceCount = spaceCount == nil ? Int(width / 7.2) : spaceCount! // 7.2 is magic number!!
		UIGraphicsBeginImageContextWithOptions(CGSize(width: width, height: height), false, UIScreen.main.scale)
		let context = UIGraphicsGetCurrentContext()
		// Set background color
		context!.setFillColor(backgroundColor.cgColor)
		context!.fill(CGRect(x: 0, y: 0, width: width, height: height))
		
		// Draw image
		image.draw(in: CGRect(x: width/2 - image.size.width/2, y: 10, width: image.size.width, height: image.size.height))
		
		// Draw View
		
		let paragraph = NSMutableParagraphStyle()
		paragraph.alignment = .center
		let textHeight = title.heightWithConstrainedWidth(width, font: font)
		(title as NSString).draw(in: CGRect(x: 0, y: height - textHeight - 5, width: width, height: textHeight), withAttributes: [NSForegroundColorAttributeName: UIColor.white, NSParagraphStyleAttributeName: paragraph, NSFontAttributeName: font])
		
		
		// Retrieve new UIImage
		let newImage: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
		UIGraphicsEndImageContext()
		
		let rowAction = UITableViewRowAction(style: .normal, title: String(repeating: " ", count: whiteSpaceCount)) { (rowAction, indexPath) in
			// Do stuff
			handler(rowAction, indexPath)
		}
		rowAction.backgroundColor = UIColor(patternImage: newImage)
		return rowAction
	}
	
	
}
// MARK: Type aliases
typealias CallBack = (Any?) -> ()
typealias NSObjectCallBack = (Any?) -> ()


// MARK: ext Data
extension Data {
	func hexEncodedString() -> String {
		return map { String(format: "%02hhx", $0) }.joined()
	}
}

// MARK: ext Character
extension Character
{
	func unicodeScalarCodePoint() -> Int
	{
		let characterString = String(self)
		let scalars = characterString.unicodeScalars
		
		return Int(scalars[scalars.startIndex].value)
	}
}

// MARK: ext NSString
extension NSString {
	var localized: String {
		return NSLocalizedString(self as String, tableName: nil, bundle: Bundle(path: Bundle.main.path(forResource: IOSUtil.lang, ofType: "lproj")!)!, value: "", comment: "")
	}
	func heightWithConstrainedWidth(_ width: CGFloat, font: UIFont) -> CGFloat {
		let constraintRect = CGSize(width: width, height: CGFloat.greatestFiniteMagnitude)
		
		let boundingBox = self.boundingRect(with: constraintRect, options: NSStringDrawingOptions.usesLineFragmentOrigin, attributes: [NSFontAttributeName: font], context: nil)
		
		return ceil(boundingBox.height)
	}
	func measureWidth(_ font: UIFont) -> CGFloat {
		return ceil(self.size(attributes: [NSFontAttributeName: font]).width)
	}
}
// MARK: ext String
extension String {
	func isNumber() -> Bool {
		let numberCharacters = CharacterSet.decimalDigits.inverted
		return !self.isEmpty && self.rangeOfCharacter(from: numberCharacters) == nil
	}
	func isAlphanumeric() -> Bool {
		return !isEmpty && range(of: "[^a-zA-Z0-9]", options: .regularExpression) == nil
	}
	var length: Int {
		get {
			return self.characters.count
		}
	}
	
	func contains(_ s: String) -> Bool {
		return self.range(of: s) != nil ? true : false
	}
	
	func replace(_ target: String, withString: String) -> String {
		return self.replacingOccurrences(of: target, with: withString, options: NSString.CompareOptions.literal, range: nil)
	}
	
	subscript (i: Int) -> Character {
		get {
			let index = characters.index(startIndex, offsetBy: i)
			return self[index]
		}
	}
	
	subscript (r: Range<Int>) -> String {
		get {
			let startIndex = self.characters.index(self.startIndex, offsetBy: r.lowerBound)
			let endIndex = self.characters.index(self.startIndex, offsetBy: r.upperBound - 1)
			
			return self[startIndex...endIndex]
		}
	}
	
	func substring(_ startIndex: Int, _ endIndex: Int) -> String {
		let start = self.characters.index(self.startIndex, offsetBy: startIndex)
		if endIndex >= self.characters.count {
			return self.substring(with: start..<self.endIndex)
		}
		let end = self.characters.index(self.startIndex, offsetBy: endIndex)
		return self.substring(with: start..<end)
	}
	
	func substring(_ startIndex: Int) -> String {
		let start = self.characters.index(self.startIndex, offsetBy: startIndex)
		return self.substring(from: start)
	}
	
	func indexOf(_ target: String) -> Int {
		let range = self.range(of: target)
		if let range = range {
			return self.characters.distance(from: self.startIndex, to: range.lowerBound)
		} else {
			return -1
		}
	}
	
	func indexOf(_ target: String, _ startIndex: Int) -> Int {
		let startRange = self.characters.index(self.startIndex, offsetBy: startIndex)
		
		let range = self.range(of: target, options: NSString.CompareOptions.literal, range: startRange..<self.endIndex)
		
		if let range = range {
			return self.characters.distance(from: self.startIndex, to: range.lowerBound)
		} else {
			return -1
		}
	}
	
	func lastIndexOf(_ target: String) -> Int {
		var index = -1
		var stepIndex = self.indexOf(target)
		while stepIndex > -1 {
			index = stepIndex
			if stepIndex + target.length < self.length {
				stepIndex = indexOf(target, stepIndex + target.length)
			} else {
				stepIndex = -1
			}
		}
		return index
	}
	
	func isMatch(_ regex: String, options: NSRegularExpression.Options) -> Bool {
		var exp:NSRegularExpression?
		
		do {
			exp = try NSRegularExpression(pattern: regex, options: options)
			
		} catch let error as NSError {
			exp = nil
			print(error.description)
			return false
		}
		
		let matchCount = exp!.numberOfMatches(in: self, options: [], range: NSMakeRange(0, self.length))
		return matchCount > 0
	}
	
	func getMatches(_ regex: String, options: NSRegularExpression.Options) -> [NSTextCheckingResult] {
		var exp:NSRegularExpression?
		
		do {
			exp = try NSRegularExpression(pattern: regex, options: options)
		} catch let error as NSError {
			print(error.description)
			exp = nil
			return []
		}
		
		let matches = exp!.matches(in: self, options: [], range: NSMakeRange(0, self.length))
		return matches
	}
	func toImage(_ width: CGFloat, _ height: CGFloat) -> UIImage? {
		let scale = 1/max(1, max(width/IOSUtil.maxThumbnailPixel, height/IOSUtil.maxThumbnailPixel))
		if let imageData = base64Data {
			return UIImage(data: imageData, scale: scale)
		} else {
			return nil
		}
	}
	var base64Data: Data? {
		return Data(base64Encoded: self, options: NSData.Base64DecodingOptions.ignoreUnknownCharacters)
	}
	func split(_ char: Character) -> [String] {
		return characters.split(separator: char).filter({ (s) -> Bool in
			return !s.isEmpty
		}).map(String.init)
	}
	func heightWithConstrainedWidth(_ width: CGFloat, font: UIFont) -> CGFloat {
		let constraintRect = CGSize(width: width, height: CGFloat.greatestFiniteMagnitude)
		
		let boundingBox = self.boundingRect(with: constraintRect, options: NSStringDrawingOptions.usesLineFragmentOrigin, attributes: [NSFontAttributeName: font], context: nil)
		
		return ceil(boundingBox.height)
	}
	func measureWidth(_ font: UIFont) -> CGFloat {
		return ceil(self.size(attributes: [NSFontAttributeName: font]).width)
	}
	var localized: String {
		return NSLocalizedString(self, tableName: nil, bundle: Bundle(path: Bundle.main.path(forResource: IOSUtil.lang, ofType: "lproj")!)!, value: "", comment: "")
	}
	func localizedWithArgs(_ args: [CVarArg]) -> String {
		return String(format: self.localized, arguments: args)
	}
	init(htmlEncodedString: String) {
		if let encodedData = htmlEncodedString.data(using: String.Encoding.utf8){
			let attributedOptions : [String: Any] = [
				NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType,
				NSCharacterEncodingDocumentAttribute: String.Encoding.utf8.rawValue
			]
			
			do{
				if let attributedString:NSAttributedString = try? NSAttributedString(data: encodedData, options: attributedOptions, documentAttributes: nil){
					self.init(attributedString.string)!
				}else{
					print("error")
					self.init(htmlEncodedString)!    //Returning actual string if there is an error
				}
			}catch{
				print("error: \(error)")
				self.init(htmlEncodedString)!    //Returning actual string if there is an error
			}
			
		}else{
			self.init(htmlEncodedString)!     //Returning actual string if there is an error
		}
	}
	var trim: String {
		return self.trimmingCharacters(
			in: CharacterSet.whitespacesAndNewlines
		)
	}
	func trim(to maximumCharacters: Int) -> String {
		return trunc(maximumCharacters)
	}
	func trunc(_ length: Int, trailing: String? = "...") -> String {
		if self.characters.count > length {
			return self.substring(to: self.characters.index(self.startIndex, offsetBy: length)) + (trailing ?? "")
		} else {
			return self
		}
	}
	func leftPadding(_ toLength: Int, withPad character: Character) -> String {
		let newLength = self.characters.count
		if newLength < toLength {
			var newStr = self
			for _ in 0..<toLength - newLength {
				newStr = String(character) + newStr
			}
			return newStr
		} else {
			return self
		}
	}
}


// MARK: ext Int
extension Int {
	func shortStr() -> String {
		if self < 1000 {
			return String(self)
		}
		else if (self < 1000000) {
			let n = self / 1000
			let m = self % 1000
			let f = m / 100
			if f != 0 {
				return String(n) + "," + String(f) + "K"
			}
			else {
				return String(n) + "K"
			}
		} else if (self < 1000000000) {
			let n = self / 1000000
			let m = self % 1000000
			let f = m / 100000
			if f != 0 {
				return String(n) + "," + String(f) + "M"
			}
			else {
				return String(n) + "M"
			}
		} else {
			return "+G";
		}
	}
}


// MARK: ext UIImage
extension UIImage {
	func tint(_ color: UIColor, blendMode: CGBlendMode) -> UIImage
	{
		let drawRect = CGRect(x: 0.0, y: 0.0, width: size.width, height: size.height)
		UIGraphicsBeginImageContextWithOptions(size, false, scale)
		let context = UIGraphicsGetCurrentContext()
		context!.clip(to: drawRect, mask: cgImage!)
		color.setFill()
		UIRectFill(drawRect)
		draw(in: drawRect, blendMode: blendMode, alpha: 1.0)
		let tintedImage = UIGraphicsGetImageFromCurrentImageContext()
		UIGraphicsEndImageContext()
		return tintedImage!
	}
	
	func base64Str(quality: CGFloat) -> String? {
		return data(quality)?.base64EncodedString(options: NSData.Base64EncodingOptions.lineLength64Characters)
	}
	var base64String : String? {
		return base64Str(quality: 0.6)
	}
	var data: Data? {
		return data(0.6)
	}
	func data(_ quality: CGFloat) -> Data? {
		return UIImageJPEGRepresentation(self, quality)
	}
	var rounded: UIImage {
		return rounded(min(size.height/2, size.width/2))
	}
	func rounded(_ radius: CGFloat) -> UIImage {
		let imageView = UIImageView(image: self)
		imageView.contentMode = .scaleAspectFit
		imageView.layer.cornerRadius = radius
		imageView.layer.masksToBounds = true
		UIGraphicsBeginImageContextWithOptions(imageView.bounds.size, false, scale)
		let context = UIGraphicsGetCurrentContext()
		imageView.layer.render(in: context!)
		let result = UIGraphicsGetImageFromCurrentImageContext()
		UIGraphicsEndImageContext()
		return result!
	}
	var circle: UIImage {
		let square = CGSize(width: min(size.width, size.height), height: min(size.width, size.height))
		let imageView = UIImageView(frame: CGRect(origin: CGPoint(x: 0, y: 0), size: square))
		imageView.contentMode = .scaleAspectFill
		imageView.image = self
		imageView.layer.cornerRadius = square.width/2
		imageView.layer.masksToBounds = true
		UIGraphicsBeginImageContextWithOptions(imageView.bounds.size, false, scale)
		let context = UIGraphicsGetCurrentContext()
		imageView.layer.render(in: context!)
		let result = UIGraphicsGetImageFromCurrentImageContext()
		UIGraphicsEndImageContext()
		return result!
	}
	func resizedImageWithSize(_ newSize: CGSize) -> UIImage {
		//        var scaledImageRect = CGRectZero
		//        let aspectWidth = newSize.width / self.size.width
		//        let aspectHeight = newSize.height / self.size.height
		//        let aspectRatio = min(aspectWidth, aspectHeight)
		//        scaledImageRect.size.width = self.size.width * aspectRatio
		//        scaledImageRect.size.height = self.size.height * aspectRatio
		//        scaledImageRect.origin.x = (newSize.width - scaledImageRect.size.width) / 2.0
		//        scaledImageRect.origin.y = (newSize.height - scaledImageRect.size.height) / 2.0
		//		let rect = CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height)
		//        UIGraphicsBeginImageContextWithOptions(newSize, false, 0 )
		//        draw(in: rect)
		//        let scaledImage = UIGraphicsGetImageFromCurrentImageContext()
		//        UIGraphicsEndImageContext()
		//
		//        return scaledImage!
		
		let widthRatio = newSize.width  / self.size.width
		let heightRatio = newSize.height / self.size.height
		let scalingFactor = max(widthRatio, heightRatio)
		let newSizeAspect = CGSize(width:  self.size.width  * scalingFactor,
                             height: self.size.height * scalingFactor)
		UIGraphicsBeginImageContextWithOptions(newSize, false, self.scale);
		let origin = CGPoint(x: (newSize.width  - newSizeAspect.width)  / 2,
		                     y: (newSize.height - newSizeAspect.height) / 2)
		self.draw(in: CGRect(origin: origin, size: newSizeAspect))
		let scaledImage = UIGraphicsGetImageFromCurrentImageContext()
		UIGraphicsEndImageContext()
		
		return scaledImage!
		
	}
}


// MARK: ext UIColor
extension UIColor {
	convenience init(red: Int, green: Int, blue: Int) {
		assert(red >= 0 && red <= 255, "Invalid red component")
		assert(green >= 0 && green <= 255, "Invalid green component")
		assert(blue >= 0 && blue <= 255, "Invalid blue component")
		
		self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: 1.0)
	}
	convenience init(hexString: String) {
		let hex = hexString.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
		var int = UInt32()
		Scanner(string: hex).scanHexInt32(&int)
		let a, r, g, b: UInt32
		switch hex.characters.count {
		case 3: // RGB (12-bit)
			(a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
		case 6: // RGB (24-bit)
			(a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
		case 8: // ARGB (32-bit)
			(a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
		default:
			(a, r, g, b) = (255, 0, 0, 0)
		}
		self.init(red: CGFloat(r) / 255, green: CGFloat(g) / 255, blue: CGFloat(b) / 255, alpha: CGFloat(a) / 255)
	}
	convenience init(netHex:Int) {
		let red = (netHex >> 16) & 0xff
		let green = (netHex >> 8) & 0xff
		let blue = netHex & 0xff
		
		assert(red >= 0 && red <= 255, "Invalid red component")
		assert(green >= 0 && green <= 255, "Invalid green component")
		assert(blue >= 0 && blue <= 255, "Invalid blue component")
		
		self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: 1.0)
	}
	convenience init(netHexWithAlpha netHex:Int) {
		let alpha = (netHex >> 24) & 0xff
		let red = (netHex >> 16) & 0xff
		let green = (netHex >> 8) & 0xff
		let blue = netHex & 0xff
		
		assert(alpha >= 0 && alpha <= 255, "Invalid alpha component")
		assert(red >= 0 && red <= 255, "Invalid red component")
		assert(green >= 0 && green <= 255, "Invalid green component")
		assert(blue >= 0 && blue <= 255, "Invalid blue component")
		
		self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: CGFloat(alpha) / 255.0)
	}
}


// MARK: ext UITextField
extension UITextField {
	var unwrappedCleanText: String {
		let str = self.text ?? ""
		return str.trim
	}
}


// MARK: ext UIView
extension UIView {
	func shake() {
		let animation = CAKeyframeAnimation(keyPath: "transform.translation.x")
		animation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionLinear)
		
		animation.values = [-20.0, 20.0, -20.0, 20.0, -10.0, 10.0, -5.0, 5.0, 0.0 ]
		let colorAnim = CAKeyframeAnimation(keyPath: "borderColor")
		
		colorAnim.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionLinear)
		let preColor = layer.borderColor
		colorAnim.values = [preColor!, UIColor.red.cgColor, preColor!]
		let borderAnim = CAKeyframeAnimation(keyPath: "borderWidth")
		
		borderAnim.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionLinear)
		let preBorder = layer.borderWidth
		if preBorder == 0 {
			layer.cornerRadius = 5
		}
		borderAnim.values = [preBorder, 1.0, preBorder]
		let group = CAAnimationGroup()
		group.duration = 0.6
		group.animations = [animation, colorAnim, borderAnim]
		
		layer.add(group, forKey: "shake")
		
		
	}
}

// MARK: ext UIButton
extension UIButton {
	func setBackgroundColor(_ color: UIColor, forState: UIControlState) {
		UIGraphicsBeginImageContext(CGSize(width: 1, height: 1))
		UIGraphicsGetCurrentContext()!.setFillColor(color.cgColor)
		UIGraphicsGetCurrentContext()!.fill(CGRect(x: 0, y: 0, width: 1, height: 1))
		let colorImage = UIGraphicsGetImageFromCurrentImageContext()
		UIGraphicsEndImageContext()
		
		self.setBackgroundImage(colorImage, for: forState)
	}
}
extension UILabel {
	dynamic var defaultFont: UIFont? {
		get { return self.font }
		set {
			// Preserve font size
			let sizeOfOldFont = self.font.pointSize
			let fontNameOfNewFont = newValue?.fontName
			self.font = UIFont(name: fontNameOfNewFont!, size: sizeOfOldFont)
		}
	}
}

extension UITextField {
	dynamic var defaultFont: UIFont? {
		get { return self.font }
		set {
			// Preserve font size
			let sizeOfOldFont = self.font?.fontDescriptor.pointSize
			let fontNameOfNewFont = newValue?.fontName
			self.font = UIFont(name: fontNameOfNewFont!, size: sizeOfOldFont!)
		}
	}
}

extension UITextView {
	dynamic var defaultFont: UIFont? {
		get { return self.font }
		set {
			// Preserve font size
			let sizeOfOldFont = self.font?.fontDescriptor.pointSize
			let fontNameOfNewFont = newValue?.fontName
			self.font = UIFont(name: fontNameOfNewFont!, size: sizeOfOldFont!)
		}
	}
}
