//
//  NewViewController.swift
//  gazette
//
//  Created by Alireza Ghias on 2/2/1396 AP.
//  Copyright © 1396 AreaTak. All rights reserved.
//

import UIKit
import PKHUD
class NewViewController: UIViewController, ViewProtocol {

	@IBOutlet weak var fileName: UILabel!
	@IBOutlet weak var date: UILabel!
	@IBOutlet weak var hashLabel: UILabel!
	@IBOutlet weak var localSave: UISwitch!
	@IBOutlet weak var useCredit: UISwitch!
	@IBOutlet weak var price: UILabel!
	@IBOutlet weak var credit: UILabel!
	@IBOutlet weak var desc: UITextView!
	
	var path: URL?
	var presenter: NewPresenter?
    override func viewDidLoad() {
        super.viewDidLoad()
		presenter = NewPresenter(self)
		presenter?.path = path!
		reload()
    }
	func reload() {
		fileName.text = presenter?.fileName()
		date.text = presenter?.date()
		hashLabel.text = presenter?.hash()
		price.text = presenter?.price()
		credit.text = presenter?.credit()
		desc.text = presenter?.desc()		
	}
	@IBAction func onTaiid(_ sender: Any) {
		HUD.show(.progress)
		presenter?.taid(desc.text, useCredit.isOn, localSave.isOn, onComplete: { (data) in
			HUD.flash(.success, delay: 0.5)
		}, onError: { (error, data) in
			HUD.flash(.error, delay: 0.5)
		})
	}
    

}
