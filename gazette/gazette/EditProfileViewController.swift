//
//  EditProfileViewController.swift
//  gazette
//
//  Created by Alireza Ghias on 2/3/1396 AP.
//  Copyright © 1396 AreaTak. All rights reserved.
//

import UIKit
import PKHUD
class EditProfileViewController: UIViewController, ViewProtocol {
	@IBOutlet weak var name: SkyFloatingLabelTextField!
	
	@IBOutlet weak var lastname: SkyFloatingLabelTextField!
	
	@IBOutlet weak var changeStatusButton: UIButton!
	
	@IBOutlet weak var confirmPassword: SkyFloatingLabelTextField!
	@IBOutlet weak var password: SkyFloatingLabelTextField!
	var presenter: ProfilePresenter?
	var status = 0 // 0 -> edit, 1 -> changePass
    override func viewDidLoad() {
        super.viewDidLoad()
		presenter = ProfilePresenter(self)
		reload()
		password.required = true
		password.customValidator = {
			if self.confirmPassword.isValid().0 {
				self.confirmPassword.errorMessage = nil
			} else {
				if !self.confirmPassword.unwrappedText.isEmpty {
					self.confirmPassword.errorMessage = self.confirmPassword.isValid().1
				} else {
					self.confirmPassword.errorMessage = nil
				}
			}
			return (true, "")
		}
		
		confirmPassword.customValidator = {
			if self.status == 0 {
				return (true, "")
			} else {
				if self.password.text == self.confirmPassword.text {
					return (true, "")
				} else {
					return (false, "PasswordNotEqual".localized)
				}
			}
		}
		gotoEditForm()
    }
	func gotoEditForm() {
		status = 0
		UIView.animate(withDuration: 0.5, animations: {
			self.password.isHidden = true
			self.confirmPassword.isHidden = true
			self.changeStatusButton.isHidden = false
			self.password.alpha = 0
			self.confirmPassword.alpha = 0
			self.changeStatusButton.alpha = 1
		}) { (success) in
			self.password.isHidden = true
			self.confirmPassword.isHidden = true
			self.changeStatusButton.isHidden = false
			self.password.alpha = 0
			self.confirmPassword.alpha = 0
			self.changeStatusButton.alpha = 1
		}
		
	}
	func gotoChangePassForm() {
		status = 1
		UIView.animate(withDuration: 0.5, animations: {
			self.password.isHidden = false
			self.confirmPassword.isHidden = false
			self.changeStatusButton.isHidden = true
			self.password.alpha = 1
			self.confirmPassword.alpha = 1
			self.changeStatusButton.alpha = 0
		}) { (success) in
			self.password.isHidden = false
			self.confirmPassword.isHidden = false
			self.changeStatusButton.isHidden = true
			self.password.alpha = 1
			self.confirmPassword.alpha = 1
			self.changeStatusButton.alpha = 0
		}
	}
	func reload() {
		name.text = CurrentUser.name
		lastname.text = CurrentUser.lastname
	}
	
	
	@IBAction func onTaiid(_ sender: Any) {
		if status == 0 {
			HUD.show(.progress)
			presenter?.editProfile(name: name.unwrappedCleanText, lastname: lastname.unwrappedCleanText, passwordHash: CurrentUser.passwordHash, onComplete: { (data) in
				HUD.flash(.success, delay: 0.5)
			}, onError: { (error, data) in
				HUD.flash(.error, delay: 0.5)
			})
		} else {
			guard password.isValid().0 else {
				return
			}
			guard confirmPassword.isValid().0 else {
				return
			}
			HUD.show(.progress)
			presenter?.editProfile(name: name.unwrappedCleanText, lastname: lastname.unwrappedCleanText, passwordHash: CryptoUtil.sha256(password.unwrappedText), onComplete: { (data) in
				HUD.flash(.success, delay: 0.5)
			}, onError: { (error, data) in
				HUD.flash(.error, delay: 0.5)
			})
		}
	}

	@IBAction func onChangeStatus(_ sender: Any) {
		gotoChangePassForm()
	}
}
