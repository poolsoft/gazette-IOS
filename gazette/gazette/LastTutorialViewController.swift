//
//  LastTutorialViewController.swift
//  gazette
//
//  Created by Alireza Ghias on 2/3/1396 AP.
//  Copyright © 1396 AreaTak. All rights reserved.
//

import UIKit

class LastTutorialViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

    }

	@IBAction func onConfirm(_ sender: Any) {
		NotificationCenter.default.post(name: Events.Start, object: nil)
	}
	
}
