//
//  HomeViewController.swift
//  gazette
//
//  Created by Alireza Ghias on 2/2/1396 AP.
//  Copyright © 1396 AreaTak. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchResultsUpdating, ViewProtocol {
	
	
	@IBOutlet weak var tableView: UITableView!
	
	var presenter: HomePresenter?
	var searchController: UISearchController?
	override func viewDidLoad() {
        super.viewDidLoad()
		presenter = HomePresenter(self)
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
		return presenter?.listAllTransactions().count ?? 0
	}
	func numberOfSections(in tableView: UITableView) -> Int {
		return 1
	}
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: "TransactionCell") as! TransactionCell
		let transaction = presenter!.listAllTransactions()[indexPath.row]
		cell.firstLine.text = transaction.transactionId
		if transaction.transactionDate != nil {
			cell.secondLine.text = DateUtil.relativeDiffFromNow(transaction.transactionDate!)
		} else {
			cell.secondLine.text = ""
		}
		if transaction.status == 0 { // Pending
			cell.statusImage.image = nil
		} else {	// Confirmed
			cell.statusImage.image = nil
		}
		return cell
	}

   
}
