//
//  ProfileViewController.swift
//  gazette
//
//  Created by Alireza Ghias on 2/2/1396 AP.
//  Copyright © 1396 AreaTak. All rights reserved.
//

import UIKit
import PKHUD
class ProfileViewController: UIViewController, ViewProtocol, NavClicked, UIScrollViewDelegate {

	@IBOutlet weak var scrollView: UIScrollView!
	@IBOutlet weak var profileImage: UIImageView!
	@IBOutlet weak var fullName: UILabel!
	@IBOutlet weak var email: UILabel!
	@IBOutlet weak var credit: UILabel!
	
	var presenter: ProfilePresenter?
    override func viewDidLoad() {
        super.viewDidLoad()
		presenter = ProfilePresenter(self)
		scrollView.delegate = self
		
		
    }
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		self.tabBarController?.navigationItem.title = "Profile".localized
		(self.tabBarController?.navigationItem as! CustomNavigationItem).showEdit()
		(self.tabBarController?.navigationItem as! CustomNavigationItem).clickedDelegate = self
		reload()
		profileImage.layer.cornerRadius = min(profileImage.frame.width, profileImage.frame.height)/2
		profileImage.layer.borderColor = UIColor.white.cgColor
		profileImage.layer.borderWidth = 2
		presenter?.requestUpdate()
		
		
	}
	func reload() {
		if let url = presenter!.myPicUrl() {
			profileImage.load.request(with: url)
		}
		fullName.text = presenter!.myName() + " " + presenter!.myLastname()
		email.text = presenter!.myEmail()
		let creditNumber = StringUtil.addSeparator(presenter!.myCredit() as NSNumber)
		let rial = "Rial".localized
		let statement = creditNumber + rial
		let creditText = NSMutableAttributedString(string: statement)
		creditText.addAttribute(NSFontAttributeName, value: AppFont.withSize(Dimensions.TextTiny), range: (statement as NSString).range(of: statement))
		creditText.addAttribute(NSFontAttributeName, value: AppFont.withSize(Dimensions.TextVeryTiny), range: (statement as NSString).range(of: rial))
		credit.attributedText = creditText
	}
	
	
	@IBAction func onBuyCredit(_ sender: Any) {
	}
	@IBAction func onFeedback(_ sender: Any) {
		if let url = URL(string: "http://sabtshod.com/#/faq") {
			UIApplication.shared.openURL(url)
		}
	}
	@IBAction func onHelp(_ sender: Any) {
		if let url = URL(string: "http://sabtshod.com/#/help") {
			UIApplication.shared.openURL(url)
		}
	}
	@IBAction func onAboutUs(_ sender: Any) {
		if let url = URL(string: "http://sabtshod.com/#/contact") {
			UIApplication.shared.openURL(url)
		}
	}
	
	func submit() {
		performSegue(withIdentifier: "EditSegue", sender: nil)
	}
	
	
	
	
}

