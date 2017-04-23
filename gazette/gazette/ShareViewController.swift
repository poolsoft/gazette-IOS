//
//  DetailViewController.swift
//  gazette
//
//  Created by Alireza Ghias on 2/3/1396 AP.
//  Copyright © 1396 AreaTak. All rights reserved.
//

import UIKit

class ShareViewController: UIViewController, ViewProtocol {
	@IBOutlet weak var transaction: UILabel!
	@IBOutlet weak var timestamp: UILabel!
	@IBOutlet weak var qrcode: UIImageView!
	var presenter: SharePresenter?
	var entity: Transaction!
    override func viewDidLoad() {
        super.viewDidLoad()
		presenter = SharePresenter(self)
		presenter?.entity = entity
		reload()
    }
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
	}
	func reload() {
		transaction.text = presenter?.transactionId()
		timestamp.text = presenter?.timeStamp()
		qrcode.image = presenter?.qrCode()
	}
	

}
