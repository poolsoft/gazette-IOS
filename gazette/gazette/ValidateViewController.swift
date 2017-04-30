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
	
	
	@IBOutlet weak var filename: UILabel!

	@IBOutlet weak var hashLabel: UILabel!
	
	
	
	
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
		HUD.show(.progress)
		presenter?.taid({ (data) in
			HUD.flash(.labeledSuccess(title: "foundTransaction".localized, subtitle: (data as? [String: Any])?["txId"] as? String ?? ""), delay: 2.0)
			
		}, { (error, data) in
			HUD.flash(.labeledError(title: "notFoundTransaction".localized, subtitle: nil), delay: 2.0)
		})
	}
}
