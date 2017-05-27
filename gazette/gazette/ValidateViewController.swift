//
//  ValidateViewController.swift
//  gazette
//
//  Created by Alireza Ghias on 2/2/1396 AP.
//  Copyright © 1396 AreaTak. All rights reserved.
//

import UIKit
import PKHUD
class ValidateViewController: UIViewController, ViewProtocol, NavClicked {
	
	
	@IBOutlet weak var qrCodeImage: UIImageView!

	@IBOutlet weak var transactionView: TransactionView!
	
	var transaction: Transaction!
	var presenter: SharePresenter?
	var detailMode = false
    override func viewDidLoad() {
        super.viewDidLoad()
		presenter = SharePresenter(self)
		presenter?.entity = transaction
		reload()
    }
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		self.navigationItem.title = detailMode ? "Detail".localized : "ValidTransaction".localized
		(self.navigationItem as! CustomNavigationItem).showShare()
		(self.navigationItem as! CustomNavigationItem).clickedDelegate = self
	}
	func reload() {
		transactionView.transactionEntity = transaction
		qrCodeImage.image = presenter?.qrCode()
	}
	func submit() {
		self.presenter?.entity = transaction
		let vc = UIActivityViewController(activityItems: [self.presenter?.link() ?? "", self.presenter!.qrCode()!], applicationActivities: nil)
		self.present(vc, animated: true, completion: nil)
	}
    
	
}
