//
//  ApnsUtil.swift
//  gazette
//
//  Created by Alireza Ghias on 3/1/1396 AP.
//  Copyright © 1396 AreaTak. All rights reserved.
//

import Foundation
class ApnsUtil: NSObject {
	class func updateCid() {
		if  !CurrentUser.token.isEmpty && !CurrentUser.cidToken.isEmpty && CurrentUser.cidUploaded != CurrentUser.cidToken {
			RestHelper.request(.post, json: false, command: "updateCid", params: ["token":CurrentUser.token, "cid":CurrentUser.cidToken], onComplete: { (_) in
				CurrentUser.cidUploaded = CurrentUser.cidToken
			}) { (_, _) in
				CurrentUser.cidUploaded = ""
			}
		} 
	}
}
