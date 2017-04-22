//
//  CustomNavBar.swift
//  app
//
//  Created by Alireza Ghias on 7/17/1395 AP.
//  Copyright © 1395 iccima. All rights reserved.
//

import UIKit

class CustomNavBar: UINavigationBar {
	required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
		semanticContentAttribute = .forceRightToLeft
		setup()
	}
	
	func setup() {
		//        let rect = CGRect(x: 0, y: 0, width: 1, height: 1)
		//        UIGraphicsBeginImageContext(rect.size)
		//        if let context = UIGraphicsGetCurrentContext() {
		//            CGContextSetFillColorWithColor(context, ColorPalette.Actionbar.CGColor)
		//            CGContextFillRect(context, rect)
		//            let image = UIGraphicsGetImageFromCurrentImageContext()
		//            self.setBackgroundImage(image, forBarMetrics: .Default)
		//        }
		//        UIGraphicsEndImageContext()
		
		// This next two lines remove bottom shadow of nav controller
		self.setBackgroundImage(UIImage(), for: .any, barMetrics: .default)
		self.shadowImage = UIImage()
		
		self.barTintColor = ColorPalette.Actionbar
		self.isTranslucent = false
		self.tintColor = ColorPalette.TextPrimary
		titleTextAttributes = [NSFontAttributeName: AppFont.withSize(Dimensions.TextMedium)]
		
	}
	
}
@objc protocol NavClicked {
	@objc optional func submit()
	@objc optional func centerClicked()
}
