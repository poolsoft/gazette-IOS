//
//  ValidatePresenter.swift
//  gazette
//
//  Created by Alireza Ghias on 2/2/1396 AP.
//  Copyright © 1396 AreaTak. All rights reserved.
//

import Foundation
class ValidatePresenter: PresenterProtocol {
	let vc: ViewProtocol
	var path: URL!
	fileprivate var file: FileHandle?
	private var transactions: [Transaction]?
	required init(_ vc: ViewProtocol) {
		self.vc = vc
	}
	func getFile() -> FileHandle? {
		if file == nil {
			do {
				file = try FileHandle(forReadingFrom: path)
			} catch {
				
			}
		}
		return file
	}
	func fileName() -> String {
		return path.lastPathComponent
	}
	
	func hash() -> String {
		if let file = getFile() {
			let data = file.readDataToEndOfFile()
			let sha256Data = CryptoUtil.sha256(data: data)
			return sha256Data.hexEncodedString()
			
		}
		return ""
	}
	
	func taid(_ transactionId: String) {
		
	}
}
