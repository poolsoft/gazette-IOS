//
//  NewPresenter.swift
//  gazette
//
//  Created by Alireza Ghias on 2/2/1396 AP.
//  Copyright © 1396 AreaTak. All rights reserved.
//

import Foundation
class NewPresenter: PresenterProtocol {
	let vc: ViewProtocol
	var localHash = ""
	var path: URL! {
		didSet {
			localHash = ""
			file = nil
		}
	}
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
	func date() -> String {
		return DateUtil.toPersian()
	}
	func hash() -> String {
		if localHash.isEmpty {
			if let file = getFile() {
				let data = file.readDataToEndOfFile()
				let sha256Data = CryptoUtil.sha256(data: data)
				localHash = sha256Data.hexEncodedString()
			} else {
				localHash = ""
			}
		}
		return localHash
	}
	func price() -> String {
		return ""
	}
	func credit() -> String {
		return ""
	}
	func desc() -> String {
		return ""
	}
	func taid(_ desc: String, _ useCredit: Bool, _ localSave: Bool, onComplete: @escaping CallBack, onError: @escaping ErrorCallBack) {
		if localSave {
			RestHelper.upload("createTnx", params: ["token":CurrentUser.token, "hash":hash(), "desc": desc], fileUrl: path, fileParam: "uploadedFile", onComplete: { (data) in
				onComplete(data)
			}, onError: { (error, data) in
				onError(error, data)
			})
		} else {
			RestHelper.request(.post, json: false, command: "createTnx", params: ["token":CurrentUser.token, "hash":hash(), "desc": desc], onComplete: { (data) in
				onComplete(data)
			}, onError: { (error, data) in
				onError(error, data)
			})
		}
	}
}
