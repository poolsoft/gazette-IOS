//
//  TransactionView.swift
//  gazette
//
//  Created by Alireza Ghias on 3/2/1396 AP.
//  Copyright © 1396 AreaTak. All rights reserved.
//

import UIKit

class TransactionView: UIView {


	@IBOutlet var mainView: UIView!
	@IBOutlet weak var statusImage: UIImageView!

	@IBOutlet weak var fileImage: UIImageView!
	@IBOutlet weak var firstLine: UILabel!
	
	@IBOutlet weak var secondLine: UILabel!
	
	@IBOutlet weak var thirdLine: UILabel!
	override init(frame: CGRect) {
		super.init(frame: frame)
		nibSetup()
	}
	
	required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
		nibSetup()
	}
	
	private func nibSetup() {
		Bundle.main.loadNibNamed("TransactionView", owner: self, options: nil)
		addSubview(mainView)
		mainView.frame = self.bounds
		mainView.backgroundColor = self.backgroundColor
	}
	
	var transactionEntity: Transaction? {
		didSet {
			
			if let entity = transactionEntity {
				self.firstLine.text = entity.transactionId
				
				if entity.desc.isEmpty {
					self.secondLine.text = "NoComment".localized
					self.secondLine.textColor = ColorPalette.TextGray
				} else {
					self.secondLine.text = entity.desc
					self.secondLine.textColor = UIColor.black
				}
				if entity.transactionDate != nil {
					self.thirdLine.text = DateUtil.relativeDiffFromNow(entity.transactionDate!)
				} else {
					self.thirdLine.text = ""
				}
				
				if entity.status == 0 { // Pending
					self.statusImage.isHidden = true
				} else {	// Confirmed
					self.statusImage.isHidden = false
				}
				if entity.fileId.isEmpty {
					self.fileImage.isHidden = true
				} else {
					self.fileImage.isHidden = false
				}
			}
		}
	}
	
	

}
