//
//  SignupStep1ViewController.swift
//  gazette
//
//  Created by Alireza Ghias on 2/2/1396 AP.
//  Copyright © 1396 AreaTak. All rights reserved.
//

import UIKit
import HTTPStatusCodes
import FontAwesome_swift
class SignupViewController: UIViewController, ViewProtocol {

	@IBOutlet weak var username: SkyFloatingLabelTextFieldWithIcon!
	
	@IBOutlet weak var background: UIImageView!
	@IBOutlet weak var logoTitle: UILabel!
	@IBOutlet weak var logo: UIImageView!
	@IBOutlet weak var passwordConfirm: SkyFloatingLabelTextFieldWithIcon!
	@IBOutlet weak var password: SkyFloatingLabelTextFieldWithIcon!
	@IBOutlet weak var confirm: UIButton!
	@IBOutlet weak var swapTitle: UIButton!
	var status = 0 // 0 -> signup, 1 -> login
	var presenter: SignupPresenter?
	
	@IBOutlet weak var verticalStack: UIStackView!
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow(notification:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
		NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow(notification:)), name: NSNotification.Name.UIKeyboardWillChangeFrame, object: nil)
		NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
	}
	
	override func viewWillDisappear(_ animated: Bool) {
		super.viewWillDisappear(animated)
		NotificationCenter.default.removeObserver(self)
	}
	
	func keyboardWillShow(notification: NSNotification) {
		
		if (!logo.isHidden) {
			logo.isHidden = true
			logoTitle.isHidden = true
		}
		
		
		
		
		
	}
	func dismissKeyboard() {
		username.resignFirstResponder()
		password.resignFirstResponder()
		passwordConfirm.resignFirstResponder()		
	}
	func keyboardWillHide() {
		if logo.isHidden {
			logo.isHidden = false
			logoTitle.isHidden = false			
		}
		
	}
	
    override func viewDidLoad() {
        super.viewDidLoad()
		presenter = SignupPresenter(self)
		gotoSignupForm()
		background.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.dismissKeyboard)))
		username.iconFont = UIFont.fontAwesome(ofSize: 15)
		username.iconText = String.fontAwesomeIcon(name: .envelopeO)
		password.iconFont = UIFont.fontAwesome(ofSize: 15)
		password.iconText = String.fontAwesomeIcon(name: .lock)
		passwordConfirm.iconFont = UIFont.fontAwesome(ofSize: 15)
		passwordConfirm.iconText = String.fontAwesomeIcon(name: .lock)
		
		
		username.required = true
		password.required = true
		password.customValidator = {
			if self.passwordConfirm.isValid().0 {
				self.passwordConfirm.errorMessage = nil
			} else {
				if !self.passwordConfirm.unwrappedText.isEmpty {
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
		let message = "WantToSignup".localized
		let mutableString = NSMutableAttributedString(string: message)
		mutableString.addAttribute(NSForegroundColorAttributeName, value: UIColor.lightGray, range: (message as NSString).range(of: message))
		mutableString.addAttribute(NSForegroundColorAttributeName, value: ColorPalette.Primary, range: (message as NSString).range(of: "SignupTitle".localized))
		swapTitle.setAttributedTitle(mutableString, for: .normal)
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
		let message = "WantToLogin".localized
		let mutableString = NSMutableAttributedString(string: message)
		mutableString.addAttribute(NSForegroundColorAttributeName, value: UIColor.lightGray, range: (message as NSString).range(of: message))
		mutableString.addAttribute(NSForegroundColorAttributeName, value: ColorPalette.Primary, range: (message as NSString).range(of: "Login".localized))
		swapTitle.setAttributedTitle(mutableString, for: .normal)
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
			presenter?.login(username.unwrappedCleanText, password.unwrappedText, { (sender) in
				self.performSegue(withIdentifier: "HomeSegue", sender: nil)
			}, { (error, data) in
				if error == HTTPStatusCode.noContent.rawValue {
					self.username.errorMessage = "NoUserFound".localized
				} else if error == HTTPStatusCode.unauthorized.rawValue {
					self.password.errorMessage = "WrongPass".localized
				}
			})
		} else {
			
			presenter?.signup(username.unwrappedCleanText, password.unwrappedText, passwordConfirm.unwrappedText, { (sender) in
				self.performSegue(withIdentifier: "HomeSegue", sender: nil)
			}, { (error, data) in
				if error == HTTPStatusCode.imUsed.rawValue {
					self.username.errorMessage = "DuplicateUser".localized
				}
			})
			
		}
		
	}
}
