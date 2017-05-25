//
//  HomeViewController.swift
//  gazette
//
//  Created by Alireza Ghias on 2/2/1396 AP.
//  Copyright © 1396 AreaTak. All rights reserved.
//

import UIKit
import XLActionController
class HomeViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchResultsUpdating, ViewProtocol {
	
	
	@IBOutlet weak var tableView: UITableView!
	
	var presenter: HomePresenter?
	var sharePresenter: SharePresenter?
	var newPresenter: NewPresenter?
	var searchController: UISearchController?
	override func viewDidLoad() {
        super.viewDidLoad()
		presenter = HomePresenter(self)
		newPresenter = NewPresenter(self)
		sharePresenter = SharePresenter(self)
        tableView.delegate = self
		tableView.dataSource = self
		tableView.tableFooterView = UIView()
		searchController =  UISearchController(searchResultsController: nil)
		tableView.tableHeaderView = searchController?.searchBar
		searchController?.searchResultsUpdater = self
		searchController?.dimsBackgroundDuringPresentation = false
		searchController?.searchBar.sizeToFit()
		searchController?.searchBar.placeholder = "Search".localized
		searchController?.searchBar.setValue("Cancel".localized, forKey:"_cancelButtonText")
		newPresenter?.updateTxFee()
		
    }
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		self.tabBarController?.navigationItem.title = "Sabtshod".localized
		(self.tabBarController?.navigationItem as! CustomNavigationItem).showNone()
		presenter?.requestTransactions()
		
	}
	func updateSearchResults(for searchController: UISearchController) {
		let search = searchController.searchBar.text ?? ""
		presenter?.searchTransaction(search)
		reload()
	}
	
	func reload() {
		self.tableView.reloadData()
	}
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return presenter?.transactions?.count ?? 0
	}
	func numberOfSections(in tableView: UITableView) -> Int {
		return 1
	}
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: "TransactionCell") as! TransactionCell
		let transactionView = cell.transactionView!
		let transaction = presenter!.transactions![indexPath.row]
		transactionView.transactionEntity = transaction
//		let bgColorView = UIView()
//		bgColorView.backgroundColor = ColorPalette.Primary
//		cell.selectedBackgroundView = bgColorView
		return cell
	}
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		tableView.deselectRow(at: indexPath, animated: true)
		let controller = TweetbotActionController()
		controller.popoverPresentationController?.sourceView = tableView.cellForRow(at: indexPath)
		controller.addAction(Action("CopyTx".localized, style: .default, handler: { (action) in
			IOSUtil.copyToClipboard(self.presenter!.transactions![indexPath.row].transactionId)
		}))
		controller.addAction(Action("Detail".localized, style: .default, handler: { (action) in
			self.performSegue(withIdentifier: "ShareSegue", sender: self.presenter!.transactions![indexPath.row])
		}))
		controller.addAction(Action("Share".localized, style: .default, handler: { (action) in
			self.sharePresenter?.entity = self.presenter!.transactions![indexPath.row]
			let vc = UIActivityViewController(activityItems: [self.sharePresenter?.transactionId() ?? "", self.sharePresenter?.qrCode()!], applicationActivities: nil)
			self.present(vc, animated: true, completion: nil)
		}))
		controller.addSection(Section())
		controller.addAction(Action("Cancel".localized, style: .cancel, handler: { (action) in
			
		}))
		present(controller, animated: true, completion: nil)
	}

	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		if segue.identifier == "ShareSegue" {
			let controller = segue.destination as! ValidateViewController
			controller.transaction = sender as! Transaction
		}
	}
}
