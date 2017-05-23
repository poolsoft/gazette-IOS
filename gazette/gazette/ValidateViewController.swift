//
//  ValidateViewController.swift
//  gazette
//
//  Created by Alireza Ghias on 2/2/1396 AP.
//  Copyright © 1396 AreaTak. All rights reserved.
//

import UIKit
import PKHUD
class ValidateViewController: UIViewController, ViewProtocol {
	
	
	@IBOutlet weak var qrCodeImage: UIImageView!

	@IBOutlet weak var transactionView: TransactionView!
	
	var transaction: Transaction!
	var presenter: SharePresenter?
    override func viewDidLoad() {
        super.viewDidLoad()
		presenter = SharePresenter(self)
		presenter?.entity = transaction
		reload()
    }
	func reload() {
		transactionView.transactionEntity = transaction
		qrCodeImage.image = presenter?.qrCode()
	}

    
	
}
