//
//  ValidateViewController.swift
//  gazette
//
//  Created by Alireza Ghias on 2/2/1396 AP.
//  Copyright © 1396 AreaTak. All rights reserved.
//

import UIKit

class ValidateViewController: UIViewController, ViewProtocol {
	var path: URL?
	var presenter: ValidatePresenter?
    override func viewDidLoad() {
        super.viewDidLoad()
		presenter = ValidatePresenter(self)
    }

    
}
