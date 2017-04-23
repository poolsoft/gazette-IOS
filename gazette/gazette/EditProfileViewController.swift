//
//  EditProfileViewController.swift
//  gazette
//
//  Created by Alireza Ghias on 2/3/1396 AP.
//  Copyright © 1396 AreaTak. All rights reserved.
//

import UIKit

class EditProfileViewController: UIViewController, ViewProtocol {
	@IBOutlet weak var name: SkyFloatingLabelTextField!
	
	@IBOutlet weak var lastname: SkyFloatingLabelTextField!
	
	@IBOutlet weak var email: SkyFloatingLabelTextField!
	
	var presenter: ProfilePresenter?
    override func viewDidLoad() {
        super.viewDidLoad()
		presenter = ProfilePresenter(self)
		reload()
		
    }
	func reload() {
		
	}
	
	
	@IBAction func onTaiid(_ sender: Any) {
	}

}
