//
//  NewViewController.swift
//  gazette
//
//  Created by Alireza Ghias on 2/2/1396 AP.
//  Copyright © 1396 AreaTak. All rights reserved.
//

import UIKit
import PKHUD
import HTTPStatusCodes
class NewViewController: UIViewController, ViewProtocol, UITextViewDelegate {

	@IBOutlet weak var fileName: UILabel!
	@IBOutlet weak var date: UILabel!
	@IBOutlet weak var hashLabel: UILabel!
	@IBOutlet weak var localSave: UISwitch!
	@IBOutlet weak var price: UILabel!
	@IBOutlet weak var credit: UILabel!
	@IBOutlet weak var desc: UITextView!
	
	@IBOutlet weak var boxHeight: NSLayoutConstraint!
	var path: URL?
	var presenter: NewPresenter?
	var profilePresenter: ProfilePresenter?
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		self.navigationItem.title = "NewTransaction".localized
		NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
		NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow), name: NSNotification.Name.UIKeyboardWillChangeFrame, object: nil)
		NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
		presenter?.updateTxFee()
		profilePresenter?.requestUpdate()
	}
	override func viewWillDisappear(_ animated: Bool) {
		super.viewWillDisappear(animated)
		NotificationCenter.default.removeObserver(self)
	}
	func keyboardWillShow() {
		boxHeight.constant = 50
	}
	func keyboardWillHide() {
		boxHeight.constant = 200
	}
    override func viewDidLoad() {
        super.viewDidLoad()
		presenter = NewPresenter(self)
		profilePresenter = ProfilePresenter(self)
		presenter?.path = path!
		reload()
		desc.delegate = self
		
    }
	func reload() {
		fileName.text = presenter?.fileName()
		date.text = presenter?.date()
		hashLabel.text = presenter?.hash()
		let priceNumber = StringUtil.addSeparator(presenter!.price() as NSNumber)
		let rial = "Rial".localized
		var statement = priceNumber + rial
		let priceText = NSMutableAttributedString(string: statement)
		priceText.addAttribute(NSFontAttributeName, value: AppFont.withSize(Dimensions.TextTiny), range: (statement as NSString).range(of: statement))
		priceText.addAttribute(NSFontAttributeName, value: AppFont.withSize(Dimensions.TextVeryTiny), range: (statement as NSString).range(of: rial))
		price.attributedText = priceText
		let creditNumber = StringUtil.addSeparator(presenter!.credit() as NSNumber)		
		statement = creditNumber + rial
		let creditText = NSMutableAttributedString(string: statement)
		creditText.addAttribute(NSFontAttributeName, value: AppFont.withSize(Dimensions.TextTiny), range: (statement as NSString).range(of: statement))
		creditText.addAttribute(NSFontAttributeName, value: AppFont.withSize(Dimensions.TextVeryTiny), range: (statement as NSString).range(of: rial))
		credit.attributedText = creditText
		desc.text = presenter?.desc()		
	}
	@IBAction func onTaiid(_ sender: Any) {
		HUD.show(.progress)
		presenter?.taid(desc.text, localSave.isOn, onComplete: { (data) in
			HUD.flash(.success, delay: 0.5)
			self.navigationController?.popViewController(animated: true)
		}, onError: { (error, data) in
			if error == HTTPStatusCode.alreadyReported.rawValue {
				HUD.flash(.label("foundTransaction".localized), delay: 2.0)
			} else {
				HUD.flash(.error, delay: 0.5)
			}
		})
	}
	func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
		if (text == "\n") {
			textView.resignFirstResponder()
		}
		return true
	}
	
	

}
