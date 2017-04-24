//
//  ProfileViewController.swift
//  gazette
//
//  Created by Alireza Ghias on 2/2/1396 AP.
//  Copyright © 1396 AreaTak. All rights reserved.
//

import UIKit
import ImageLoader
class ProfileViewController: UIViewController, ViewProtocol, NavClicked, UIScrollViewDelegate {

	@IBOutlet weak var scrollView: UIScrollView!
	@IBOutlet weak var profileImage: UIImageView!
	@IBOutlet weak var fullName: UILabel!
	@IBOutlet weak var email: UILabel!
	@IBOutlet weak var credit: UILabel!
	@IBOutlet weak var profileImageTop: NSLayoutConstraint!
	@IBOutlet weak var profileImageHeight: NSLayoutConstraint!
	var defaultHeight: CGFloat = 0
	var defaultTop: CGFloat = 0
	var presenter: ProfilePresenter?
    override func viewDidLoad() {
        super.viewDidLoad()
		presenter = ProfilePresenter(self)
		presenter?.requestUpdate()
		scrollView.delegate = self
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
		defaultHeight = profileImageHeight.constant
		defaultTop = profileImageTop.constant
		
	}
	func reload() {
		if let url = presenter!.myPicUrl() {
			profileImage.load.request(with: url)
		}
		fullName.text = presenter!.myName() + " " + presenter!.myLastname()
		email.text = presenter!.myEmail()
		credit.text = StringUtil.addSeparator(presenter!.myCredit() as NSNumber)
	}
	func scrollViewDidScroll(_ scrollView: UIScrollView) {
		var newheight = defaultHeight - scrollView.contentOffset.y
		if newheight > defaultHeight {
			newheight = defaultHeight
		}
		if newheight < defaultHeight/2 {
			newheight = defaultHeight/2
		}
		profileImageHeight.constant = newheight
		profileImage.layer.cornerRadius = newheight/2
		profileImageTop.constant = defaultTop + (defaultHeight - newheight)
		
	}
	
	@IBAction func onBuyCredit(_ sender: Any) {
	}
	@IBAction func onFeedback(_ sender: Any) {
	}
	@IBAction func onHelp(_ sender: Any) {
	}
	@IBAction func onAboutUs(_ sender: Any) {
	}
	@IBAction func onExit(_ sender: Any) {
		IOSUtil.alertTwoChoice("AreYouSureExit".localized, controller: self, positiveAction: "Ok".localized, negativeAction: "Cancel".localized, positiveHandler: { (action) in
			self.presenter?.logout()
			let storyBoard = UIStoryboard(name: "Main", bundle: nil)
			let mainViewController = storyBoard.instantiateInitialViewController()
			self.present(mainViewController!, animated: true, completion: nil)
		}) { (action) in
			
		}
	}
	func submit() {
		performSegue(withIdentifier: "EditSegue", sender: nil)
	}
	
	
	
}
