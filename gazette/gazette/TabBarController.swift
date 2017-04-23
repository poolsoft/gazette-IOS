//
//  TabBarController.swift
//  gazette
//
//  Created by Alireza Ghias on 2/2/1396 AP.
//  Copyright © 1396 AreaTak. All rights reserved.
//

import UIKit

class TabBarController: UITabBarController, UITabBarControllerDelegate {
	let imagePickerUtil = ImagePickerUtil()
	var newSegue = false
	var validateSegue = false
    override func viewDidLoad() {
        super.viewDidLoad()
		self.delegate = self
		self.selectedIndex = 3
		imagePickerUtil.onPicSaved = {(path) in
			if self.newSegue {
				self.performSegue(withIdentifier: "NewSegue", sender: URL(fileURLWithPath: path as! String))
			} else if self.validateSegue {
				self.performSegue(withIdentifier: "ValidateSegue", sender: URL(fileURLWithPath: path as! String))
			}
		}
    }
	func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
		let item = viewController.tabBarItem
		if item?.tag == 1 { // NEW
			return false
		} else if item?.tag == 2 { // Validate
			return false
		}
		return true
	}
	override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
		validateSegue = false
		newSegue = false
		if item.tag == 1 { // NEW
			newSegue = true
			imagePickerUtil.showImagePickerOptions(self)
		} else if item.tag == 2 { // Validate
			validateSegue = true
			imagePickerUtil.showImagePickerOptions(self, showCamera: false)
		}
		
	}
	
	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		if segue.identifier == "NewSegue" {
			let controller = segue.destination as! NewViewController
			controller.path = sender as! URL
		} else if segue.identifier == "ValidateSegue" {
			let controller = segue.destination as! ValidateViewController
			controller.path = sender as! URL
		}
	}
	

}
