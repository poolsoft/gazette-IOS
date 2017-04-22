//
//  CustomNavigationItem.swift
//  app
//
//  Created by Alireza Ghias on 7/14/1395 AP.
//  Copyright © 1395 iccima. All rights reserved.
//

import UIKit

class CustomNavigationItem: UINavigationItem {
	
	var rightButton: UIBarButtonItem?
	var clickedDelegate: NavClicked?
	let menuImage = UIImage(named: "Menu")!
	let nextImage = UIImage(named: "Next")!
	let editImage = UIImage(named: "Edit")!
	let addImage = UIImage(named: "Add")!
	enum CustomNavMenuItems: Int {
		case menu = 0
		case next = 1
		case edit = 2
		case add = 3
		case none = -1
	}
	
	var nextItem: CustomNavMenuItems = .none
	func showNext() {
		nextItem = .next
		prepareNextItem()
	}
	
	
	
	func showMenu() {
		nextItem = .menu
		prepareNextItem()
	}
	
	func showEdit() {
		nextItem = .edit
		prepareNextItem()
	}
	
	func showNone() {
		nextItem = .none
		prepareNextItem()
	}
	func showAdd() {
		nextItem = .add
		prepareNextItem()
	}
	
	func prepareNextItem() {
		switch nextItem {
		case .menu:
			(rightButton?.customView as? UIImageView)?.image = menuImage
		case .next:
			(rightButton?.customView as? UIImageView)?.image = nextImage
		case .edit:
			(rightButton?.customView as? UIImageView)?.image = editImage
		case .add:
			(rightButton?.customView as? UIImageView)?.image = addImage
		
		default:
			(rightButton?.customView as? UIImageView)?.image = nil
		}
	}
	required init?(coder: NSCoder) {
		super.init(coder: coder)
		
		setup()
	}
	override var title: String? {
		didSet {
			(self.titleView as? UILabel)?.text = title
			self.titleView?.sizeToFit()
		}
	}
	func prepareLabelTitleView() {
		let label = UILabel()
		label.font = AppFont.withSize(Dimensions.TextMedium)
		label.textColor = ColorPalette.TextPrimary
		label.text = title
		label.sizeToFit()
		self.titleView = label
	}
	
	
	func setup() {
		rightButton = UIBarButtonItem(title: "", style: UIBarButtonItemStyle.plain, target: self, action: #selector(self.submit))
		let naviButton = UIBarButtonItem(barButtonSystemItem: .fixedSpace, target: nil, action: nil)
		naviButton.width = -10
		let nextImageView = UIImageView()
		nextImageView.frame.size = CGSize(width: 44, height: 44)
		nextImageView.contentMode = .left
		rightButton!.customView = nextImageView
		rightButton?.customView?.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.submit)))
		rightBarButtonItems = [naviButton, rightButton!]
		prepareLabelTitleView()
		
		// Custom back button for following Views in navigation
		let backButton = UIBarButtonItem(title: "", style: UIBarButtonItemStyle.plain, target: nil, action: nil)
		backBarButtonItem = backButton;
		leftItemsSupplementBackButton = true
		
	}
	
	func centerClicked() {
		clickedDelegate?.centerClicked?()
	}
	func submit() {
		if (rightButton?.customView as? UIImageView)?.image != nil {
			clickedDelegate?.submit?()
		}
	}
}
