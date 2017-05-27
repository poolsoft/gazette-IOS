//
//  ValidateViewController.swift
//  gazette
//
//  Created by Alireza Ghias on 2/2/1396 AP.
//  Copyright © 1396 AreaTak. All rights reserved.
//

import UIKit
import PKHUD
import MBProgressHUD
class ValidateViewController: UIViewController, ViewProtocol, NavClicked, UIDocumentInteractionControllerDelegate {
	
	
	@IBOutlet weak var qrCodeImage: UIImageView!

	@IBOutlet weak var transactionView: TransactionView!
	
	@IBOutlet weak var downloadButton: UIButton!
	var transaction: Transaction!
	var presenter: SharePresenter?
	var detailMode = false
	var downloadMode = false
	var openMode = false
	
    override func viewDidLoad() {
        super.viewDidLoad()
		presenter = SharePresenter(self)
		presenter?.entity = transaction
		reload()
    }
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		self.navigationItem.title = detailMode ? "Detail".localized : "ValidTransaction".localized
		(self.navigationItem as! CustomNavigationItem).showShare()
		(self.navigationItem as! CustomNavigationItem).clickedDelegate = self
	}
	func reload() {
		transactionView.transactionEntity = transaction
		qrCodeImage.image = presenter?.qrCode()
		downloadMode = presenter?.shouldDownload() ?? false
		openMode = presenter?.shouldOpen() ?? false
		if downloadMode {
			downloadButton.setTitle("Download".localized, for: .normal)
			downloadButton.isHidden =  false
		} else if openMode {
			downloadButton.setTitle("Open".localized, for: .normal)
			downloadButton.isHidden =  false
		} else {
			downloadButton.isHidden =  true
		}
	}
	func submit() {
		self.presenter?.entity = transaction
		let vc = UIActivityViewController(activityItems: [self.presenter?.link() ?? "", self.presenter!.qrCode()!], applicationActivities: nil)
		self.present(vc, animated: true, completion: nil)
	}
    
	@IBAction func onDownloadButtonClicked(_ sender: Any) {
		if downloadMode {
			let hud = MBProgressHUD.showAdded(to: self.view, animated: true)
			hud.mode = .determinateHorizontalBar
			
			RestHelper.download(presenter!.mediaId(), onProgress: { progress in
				IOSUtil.postDelay({
					hud.progress = Float(progress)
				}, seconds: 0)
			}, onComplete: { (path) -> (Void) in
				self.presenter!.setDownloadPath(url: path!)
				IOSUtil.postDelay({
					hud.hide(animated: true)
				}, seconds: 0)
			}, onError: { (Void) -> (Void) in
				IOSUtil.postDelay({
					hud.hide(animated: true)
				}, seconds: 0)
				
			})
		} else if openMode {
			let url = URL(fileURLWithPath: self.presenter!.fileAddress())
			let controller = UIDocumentInteractionController(url: url)
			controller.delegate = self
			controller.presentPreview(animated: true)
		}
	}
	func documentInteractionControllerViewControllerForPreview(_ controller: UIDocumentInteractionController) -> UIViewController {
		return self
	}
	
}
