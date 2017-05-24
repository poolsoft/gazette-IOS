//
//  EditProfileViewController.swift
//  gazette
//
//  Created by Alireza Ghias on 2/3/1396 AP.
//  Copyright © 1396 AreaTak. All rights reserved.
//

import UIKit
import PKHUD
class EditProfileViewController: UIViewController, ViewProtocol, UITextFieldDelegate {
	@IBOutlet weak var name: SkyFloatingLabelTextField!
	
	@IBOutlet weak var profileImage: UIImageView!
	@IBOutlet weak var lastname: SkyFloatingLabelTextField!
	
	@IBOutlet weak var email: UILabel!
	@IBOutlet weak var fullName: UILabel!
	@IBOutlet weak var changeStatusButton: UIButton!
	
	@IBOutlet weak var confirmPassword: SkyFloatingLabelTextField!
	@IBOutlet weak var password: SkyFloatingLabelTextField!
	var presenter: ProfilePresenter?
	var status = 0 // 0 -> edit, 1 -> changePass
	let imagePicker = ImagePickerUtil()
    override func viewDidLoad() {
        super.viewDidLoad()
		presenter = ProfilePresenter(self)
		reload()
		name.delegate = self
		lastname.delegate = self
		password.delegate = self
		confirmPassword.delegate = self
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
		
		imagePicker.onPicSaved = { (path) in
			HUD.show(.progress)
			self.presenter!.editProfile(name: CurrentUser.name, lastname: CurrentUser.lastname, passwordHash: CurrentUser.passwordHash, pic: URL(fileURLWithPath: path as! String), onComplete: { (data) in
				HUD.flash(.success, delay: 0.5)
				IOSUtil.postDelay({
					self.profileImage.load.removeCache()
					self.reload()
				}, seconds: 0)
				
			}, onError: { (error, data) in
				HUD.flash(.error, delay: 0.5)
			})
		}
		
		gotoEditForm()
    }
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		self.navigationItem.title = "Profile".localized
		profileImage.layer.cornerRadius = min(profileImage.frame.width, profileImage.frame.height)/2
		profileImage.layer.borderColor = UIColor.white.cgColor
		profileImage.layer.borderWidth = 2
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
		if let url = presenter!.myPicUrl() {
			profileImage.load.request(with: url)
		}
		fullName.text = presenter!.myName() + " " + presenter!.myLastname()
		email.text = presenter!.myEmail()
		name.text = CurrentUser.name
		lastname.text = CurrentUser.lastname
	}
	
	
	@IBAction func onTaiid(_ sender: Any) {
		if status == 0 {
			HUD.show(.progress)
			presenter?.editProfile(name: name.unwrappedCleanText, lastname: lastname.unwrappedCleanText, passwordHash: CurrentUser.passwordHash, onComplete: { (data) in
				HUD.flash(.success, delay: 0.5)
				self.navigationController?.popViewController(animated: true)
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
				self.navigationController?.popViewController(animated: true)
			}, onError: { (error, data) in
				HUD.flash(.error, delay: 0.5)
			})
		}
	}

	@IBAction func onChangeStatus(_ sender: Any) {
		gotoChangePassForm()
	}
	
	func textFieldShouldReturn(_ textField: UITextField) -> Bool {
		textField.resignFirstResponder()
		return false
	}
	@IBAction func onProfilePicClicked(_ sender: Any) {
		imagePicker.showImagePickerOptions(self)
	}
}
