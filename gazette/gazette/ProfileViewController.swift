//
//  ProfileViewController.swift
//  gazette
//
//  Created by Alireza Ghias on 2/2/1396 AP.
//  Copyright © 1396 AreaTak. All rights reserved.
//

import UIKit
import ImageLoader
class ProfileViewController: UIViewController, ViewProtocol, NavClicked {

	@IBOutlet weak var profileImage: UIImageView!
	@IBOutlet weak var fullName: UILabel!
	@IBOutlet weak var email: UILabel!
	@IBOutlet weak var credit: UILabel!
	var presenter: ProfilePresenter?
    override func viewDidLoad() {
        super.viewDidLoad()
		presenter = ProfilePresenter(self)
    }
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		self.tabBarController?.navigationItem.title = "Profile".localized
		(self.tabBarController?.navigationItem as! CustomNavigationItem).showEdit()
		(self.tabBarController?.navigationItem as! CustomNavigationItem).clickedDelegate = self
		reload()
		profileImage.layer.cornerRadius = min(profileImage.frame.width, profileImage.frame.height)/2
		profileImage.layer.borderColor = UIColor.red.cgColor
		profileImage.layer.borderWidth = 1
		
	}
	func reload() {
		profileImage.load.request(with: presenter!.myPicUrl())
		fullName.text = presenter!.myName() + " " + presenter!.myLastname()
		email.text = presenter!.myEmail()
		credit.text = StringUtil.addSeparator(presenter!.myCredit() as NSNumber)
	}

	@IBAction func onBuyCredit(_ sender: Any) {
	}
	@IBAction func onFeedback(_ sender: Any) {
	}
	@IBAction func onHelp(_ sender: Any) {
	}
	@IBAction func onAboutUs(_ sender: Any) {
	}
	
	func submit() {
		performSegue(withIdentifier: "EditSegue", sender: nil)
	}
}
