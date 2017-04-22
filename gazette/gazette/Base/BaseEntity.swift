//
//  BaseEntity.swift
//  app
//
//  Created by alireza ghias on 6/30/16.
//  Copyright © 2016 iccima. All rights reserved.
//

import Foundation
import RealmSwift

class BaseEntity: Object{
	dynamic var id: String?
	dynamic var _created: Date?
	dynamic var _modified: Date?
	override class func primaryKey() -> String? {
		return "id"
	}
	override func isEqual(_ object: Any?) -> Bool {
		if object != nil {
			if id == nil && (object as! BaseEntity).id == nil {
				return true
			}
			if id != nil && (object as! BaseEntity).id != nil {
				return id == (object as! BaseEntity).id
			}
		}
		return false
	}
	override var hash: Int {
		return id?.hash ?? super.hash
	}
	override var hashValue: Int {
		return hash
	}
	
	
	
	
}
func ==(first: BaseEntity, another: BaseEntity) -> Bool {
	return first.isEqual(another)
}
