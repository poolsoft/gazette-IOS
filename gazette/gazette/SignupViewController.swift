//
//  SignupStep1ViewController.swift
//  gazette
//
//  Created by Alireza Ghias on 2/2/1396 AP.
//  Copyright © 1396 AreaTak. All rights reserved.
//

import UIKit

class SignupViewController: UIViewController, ViewProtocol {

	@IBOutlet weak var username: SkyFloatingLabelTextField!
	
	@IBOutlet weak var passwordConfirm: SkyFloatingLabelTextField!
	@IBOutlet weak var password: SkyFloatingLabelTextField!
	@IBOutlet weak var confirm: UIButton!
	@IBOutlet weak var swapTitle: UIButton!
	var status = 0 // 0 -> signup, 1 -> login
	var presenter: SignupPresenter?
    override func viewDidLoad() {
        super.viewDidLoad()
		presenter = SignupPresenter(self)
		gotoSignupForm()
		username.required = true
		password.required = true
		password.customValidator = {
			if self.passwordConfirm.isValid().0 {
				self.passwordConfirm.errorMessage = nil
			} else {
				if !self.passwordConfirm.unwrappedCleanText.isEmpty {
					self.passwordConfirm.errorMessage = self.passwordConfirm.isValid().1
				} else {
					self.passwordConfirm.errorMessage = nil
				}
			}
			return (true, "")
		}
		username.customValidator = {
			return (IOSUtil.isValidEmail(self.username.unwrappedCleanText), "EmailIsNotValid".localized)
		}
		passwordConfirm.customValidator = {
			if self.status == 1 {
				return (true, "")
			} else {
				if self.password.text == self.passwordConfirm.text {
					return (true, "")
				} else {
					return (false, "PasswordNotEqual".localized)
				}
			}
		}
    }
	func gotoLoginForm() {
		swapTitle.setTitle("WantToSignup".localized, for: .normal)
		confirm.setTitle("Login".localized, for: .normal)
		status = 1
		UIView.animate(withDuration: 0.5, animations: {
			self.passwordConfirm.isHidden = true
			self.passwordConfirm.alpha = 0
		}) { (success) in
			self.passwordConfirm.isHidden = true
			self.passwordConfirm.alpha = 0
		}
	}
	func gotoSignupForm() {
		swapTitle.setTitle("WantToLogin".localized, for: .normal)
		confirm.setTitle("Signup".localized, for: .normal)
		status = 0
		UIView.animate(withDuration: 0.5, animations: {
			self.passwordConfirm.isHidden = false
			self.passwordConfirm.alpha = 1
		}) { (success) in
			self.passwordConfirm.isHidden = false
			self.passwordConfirm.alpha = 1
		}
	}
	@IBAction func onSwapForm(_ sender: Any) {
		if status == 0 {
			gotoLoginForm()
		} else {
			gotoSignupForm()
		}
	}
    
	@IBAction func onConfirm(_ sender: Any) {
		guard username.isValid().0 else {
			return
		}
		guard password.isValid().0 else {
			return
		}
		guard passwordConfirm.isValid().0 else {
			return
		}
		
		if status == 1 {
			presenter?.login(username.unwrappedCleanText, password.unwrappedCleanText, { (sender) in
				self.performSegue(withIdentifier: "HomeSegue", sender: nil)
			})
		} else {
			
			presenter?.signup(username.unwrappedCleanText, password.unwrappedCleanText, { (sender) in
				self.performSegue(withIdentifier: "HomeSegue", sender: nil)
			})
			
		}
		
	}
}
