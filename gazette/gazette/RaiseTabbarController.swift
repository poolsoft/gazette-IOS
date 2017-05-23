//
//  RaiseTabbarController.swift
//  gazette
//
//  Created by Alireza Ghias on 3/2/1396 AP.
//  Copyright © 1396 AreaTak. All rights reserved.
//

import UIKit
open class RaisedTabBarController: UITabBarController {
	
	override open func viewDidLoad() {
		super.viewDidLoad()
	}
	
	open func insertEmptyTabItem(_ title: String, atIndex: Int) {
		let vc = UIViewController()
		vc.tabBarItem = UITabBarItem(title: title, image: nil, tag: 0)
		vc.tabBarItem.isEnabled = false
		self.viewControllers?.insert(vc, at: atIndex)
		
	}
	
	
	
	open func addRaisedButton(_ buttonImage: UIImage?, highlightImage: UIImage?, offset:CGFloat? = nil, selector: Selector, index: Int) {
		if let buttonImage = buttonImage {
			let button = UIButton(type: UIButtonType.custom)
			button.autoresizingMask = [UIViewAutoresizing.flexibleRightMargin, UIViewAutoresizing.flexibleLeftMargin, UIViewAutoresizing.flexibleBottomMargin, UIViewAutoresizing.flexibleTopMargin]
			
			button.frame = CGRect(x: 0.0, y: 0.0, width: buttonImage.size.width, height: buttonImage.size.height)
			button.setBackgroundImage(buttonImage, for: UIControlState())
			button.setBackgroundImage(highlightImage, for: UIControlState.highlighted)
			
			let heightDifference = buttonImage.size.height - self.tabBar.frame.size.height
			
			if (heightDifference < 0) {
				button.center = CGPoint.zero
			}
			else {
				var center = CGPoint.zero
				center.y -= heightDifference / 2.0
				
				button.center = center
			}
			
			if offset != nil
			{
				//Add offset
				var center = button.center
				center.y = center.y + offset!
				button.center = center
			}
			
			button.addTarget(self, action: selector, for: UIControlEvents.touchUpInside)
			self.tabBar.subviews[index].addSubview(button)
			self.tabBar.subviews[index].bringSubview(toFront: button)
		}
	}
	
	
}
