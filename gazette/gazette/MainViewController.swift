//
//  MainViewController.swift
//  gazette
//
//  Created by Alireza Ghias on 2/2/1396 AP.
//  Copyright © 1396 AreaTak. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
		
    }
	override func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(animated)
		if CurrentUser.token.isEmpty {
			performSegue(withIdentifier: "TutorialSegue", sender: nil)
		} else {
			performSegue(withIdentifier: "HomeSegue", sender: nil)
		}
	}
   

}
