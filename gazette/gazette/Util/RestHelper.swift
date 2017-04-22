//
//  RestHelper.swift
//  app
//
//  Created by alireza ghias on 6/29/16.
//  Copyright © 2016 iccima. All rights reserved.
//

import Foundation
import Alamofire
open class MyServerTrustPolicyManager: ServerTrustPolicyManager {
	
	// Override this function in order to trust any self-signed https
	open override func serverTrustPolicy(forHost host: String) -> ServerTrustPolicy? {
		if !Constants.useSSL {
			return ServerTrustPolicy.disableEvaluation
		} else {
			return super.serverTrustPolicy(forHost: host)
		}
	}
}

class RestHelper {
	static let trustPolicies = MyServerTrustPolicyManager(policies: [:])
	static let manager = Alamofire.SessionManager(configuration: URLSessionConfiguration.default, delegate: SessionDelegate(), serverTrustPolicyManager: trustPolicies)
	static func request(_ method: HTTPMethod, command: String, params: [String: Any]?, onComplete: @escaping (_ body: AnyObject?, _ bundle: [String: AnyObject]) -> (), onError: @escaping (_ error: Int?, _ body: String?, _ bundle: [String: AnyObject]?) -> ()){
		let enc: ParameterEncoding = (method == HTTPMethod.post ? JSONEncoding.default : URLEncoding.default)
		UIApplication.shared.isNetworkActivityIndicatorVisible = true
		print("sending request \(command)")
		
		manager.request(URL(string: Constants.SERVER_ADDRESS + command)!, method: method, parameters: params, encoding: enc, headers: ["Content-Type": "application/json"]).responseJSON { (response) in
			UIApplication.shared.isNetworkActivityIndicatorVisible = false
			print("received result for \(command)")
			guard response.result.isSuccess else {
				print("Error : \(String(describing: response.result.error))")
				onError(nil, nil, nil)
				return
			}
			guard let value = response.result.value as? [String: AnyObject], let bundle = value["bundle"] as? [String: AnyObject] else {
				print("Malformed data received")
				onError(nil, nil, nil)
				return
			}
			if value["status"] as? Int == 200{
				onComplete(value["body"], bundle)
			}else{
				onError(value["status"] as? Int, value["body"] as? String, bundle)
			}
			
		}
		
	}
	
	static func upload(_ command: String, headers: [String: String]?, fileUrl: URL, onComplete: @escaping (_ body: String?, _ bundle: [String: AnyObject]) -> (), onError: @escaping (_ error: Int?, _ body: String?, _ bundle: [String: AnyObject]?) -> ()) {
		var sentHeaders = [String: String]()
		if headers != nil {
			for k in headers! {
				sentHeaders[k.0] = k.1
			}
		}
		sentHeaders["Content-Type"] = "multipart/form-data"
		let url = URL(string: Constants.SERVER_ADDRESS + command)!
		manager.upload(multipartFormData: { (multipart) in
			multipart.append(fileUrl, withName: "files")
		}, usingThreshold: UInt64.init(), to: url, method: .post, headers: sentHeaders) { (encodingResult) in
			switch encodingResult {
			case .success(let upload, _, _):
				upload.responseJSON { response in
					print("response = \(response)")
					guard response.result.isSuccess else {
						print("Error : \(String(describing: response.result.error))")
						onError(nil, nil, nil)
						return
					}
					guard let value = response.result.value as? [String: AnyObject], let bundle = value["bundle"] as? [String: AnyObject] else {
						print("Malformed data received")
						onError(nil, nil, nil)
						return
					}
					if value["status"] as? Int == 200{
						onComplete(value["body"] as? String, bundle)
					}else{
						onError(value["status"] as? Int, value["body"] as? String, bundle)
					}
				}
			case .failure(let encodingError):
				print(encodingError)
			}
		}
		
	}
	static func download(_ mediaId: String, onProgress: ((Int) -> Void)?, onComplete: @escaping (URL?)->(Void), onError: @escaping (Void) -> (Void)) {
		var fileUrl: URL?
		let url = URL(string: Constants.SERVER_ADDRESS + "download?token=" + CurrentUser.token + "&id=" + mediaId)!
		manager.download(url) { (url: URL, response: HTTPURLResponse) -> (destinationURL: URL, options: DownloadRequest.DownloadOptions) in
			let fileName = response.allHeaderFields["fileName"] as? String ?? NSUUID().uuidString
			let pathComponent = IOSUtil.getCache("downloads", String(NSDate().timeIntervalSince1970) + "_" + fileName)
			fileUrl = URL(fileURLWithPath: pathComponent)
			return (fileUrl!, DownloadRequest.DownloadOptions.removePreviousFile)
			
			}.downloadProgress { (progress) in
				onProgress?(Int(progress.fractionCompleted * 100))
			}.response { response in
				if let error = response.error {
					print("Failed with error: \(error)")
					onError()
				} else {
					print("Downloaded file successfully \(mediaId) in \(fileUrl)")
					onComplete(fileUrl)
				}
		}
	}
	
	
	
	
	static func downloadProfile(_ chatRoute: String, username: String, onComplete: @escaping (URL?)->(Void), onError: @escaping (Void) -> (Void)) {
		var fileUrl: URL?
		let url = URL(string: Constants.SERVER_ADDRESS + "downloadProfile?token=" + CurrentUser.token + "&chatRoute=" + chatRoute + "&username=" + username)!
		manager.download(url) { (url, response) -> (destinationURL: URL, options: DownloadRequest.DownloadOptions) in
			let fileName = response.allHeaderFields["fileName"] as? String ?? NSUUID().uuidString
			let pathComponent = IOSUtil.getCache("shouldDelete_\(chatRoute)", String(NSDate().timeIntervalSince1970) + "_" + fileName)
			fileUrl = URL(fileURLWithPath: pathComponent)
			return (fileUrl!, DownloadRequest.DownloadOptions.removePreviousFile)
			}.response { response in
				if let error = response.error {
					print("Failed with error: \(error)")
					onError()
				} else {
					print("Downloaded file successfully \(chatRoute)_\(username)")
					onComplete(fileUrl)
				}
		}
	}
}
