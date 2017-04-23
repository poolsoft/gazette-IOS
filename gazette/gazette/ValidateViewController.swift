//
//  ValidateViewController.swift
//  gazette
//
//  Created by Alireza Ghias on 2/2/1396 AP.
//  Copyright © 1396 AreaTak. All rights reserved.
//

import UIKit

class ValidateViewController: UIViewController, ViewProtocol {
	
	
	@IBOutlet weak var filename: UILabel!

	@IBOutlet weak var hashLabel: UILabel!
	
	@IBOutlet weak var transactionInput: UITextField!
	
	
	
	var path: URL!
	var presenter: ValidatePresenter?
    override func viewDidLoad() {
        super.viewDidLoad()
		presenter = ValidatePresenter(self)
		presenter?.path = path
		reload()
    }
	func reload() {
		filename.text = presenter?.fileName()
		hashLabel.text = presenter?.hash()
	}

    
	@IBAction func onTaiid(_ sender: Any) {
		presenter?.taid(transactionInput.text ?? "")
	}
}
