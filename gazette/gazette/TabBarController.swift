//
//  TabBarController.swift
//  gazette
//
//  Created by Alireza Ghias on 2/2/1396 AP.
//  Copyright © 1396 AreaTak. All rights reserved.
//

import UIKit
import PKHUD
class TabBarController: UITabBarController, UITabBarControllerDelegate, ViewProtocol {
	let imagePickerUtil = ImagePickerUtil()
	var newSegue = false
	var validateSegue = false
	var dictionatyImages = [UITabBarItem: UIImage?]()
	var presenter: ProfilePresenter?
	var validatePresenter: ValidatePresenter?
    override func viewDidLoad() {
        super.viewDidLoad()
		presenter = ProfilePresenter(self)
		validatePresenter = ValidatePresenter(self)
		self.delegate = self
		self.selectedIndex = 4
		imagePickerUtil.onPicSaved = {(path) in
			if self.newSegue {
				self.performSegue(withIdentifier: "NewSegue", sender: URL(fileURLWithPath: path as! String))
			} else if self.validateSegue {
				self.validatePresenter?.path = URL(fileURLWithPath: path as! String)
				IOSUtil.postDelay({
					HUD.show(.progress)
					self.validatePresenter?.validate({ (data) in
						HUD.flash(.success, delay: 0.5)
						let transaction = Transaction()
						transaction.update(data as! [String: Any])
						self.performSegue(withIdentifier: "ValidateSegue", sender: transaction)
						
					}, { (error, data) in
						HUD.flash(.labeledError(title: "notFoundTransaction".localized, subtitle: nil), delay: 2.0)
					})
					
				}, seconds: 0)
				
			}
		}
		imagePickerUtil.onCancel = { (_) in
			self.backToDefaultImages()
		}
		
    }
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		backToDefaultImages()
	}
	func onNewClicked() {
		newSegue = true
		imagePickerUtil.showImagePickerOptions(self)
	}
	func onValidateClicked() {
		validateSegue = true
		imagePickerUtil.showImagePickerOptions(self, showCamera: false)		
	}
	func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
		let item = viewController.tabBarItem
		if item?.tag == 1 { // NEW
			return false
		} else if item?.tag == 2 { // Validate
			return false
		} else if item?.tag == 4 { // Exit
			return false
		}
		return true
	}
	override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
		validateSegue = false
		newSegue = false
		if item.tag == 1 { // NEW
			dictionatyImages[item] = item.image
			onNewClicked()
			item.image = item.selectedImage
		} else if item.tag == 2 { // Validate
			dictionatyImages[item] = item.image
			onValidateClicked()
			item.image = item.selectedImage
		} else if item.tag == 4 { // Exit
			dictionatyImages[item] = item.image
			item.image = item.selectedImage
			IOSUtil.alertTwoChoice("AreYouSureExit".localized, controller: self, positiveAction: "Ok".localized, negativeAction: "Cancel".localized, positiveHandler: {
				self.presenter?.logout()
				let storyBoard = UIStoryboard(name: "Main", bundle: nil)
				let mainViewController = storyBoard.instantiateInitialViewController()
				self.present(mainViewController!, animated: true, completion: nil)
			}) { 
				self.backToDefaultImages()
			}
		} else {
			backToDefaultImages()
		}
		
	}
	func backToDefaultImages() {
		IOSUtil.postDelay({ 
			for ent in self.dictionatyImages {
				ent.key.image = ent.value
			}
		}, seconds: 0)
		
	}
	
	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		if segue.identifier == "NewSegue" {
			let controller = segue.destination as! NewViewController
			controller.path = sender as! URL
		} else if segue.identifier == "ValidateSegue" {
			let controller = segue.destination as! ValidateViewController
			controller.transaction = sender as! Transaction
		}
	}
	

}

