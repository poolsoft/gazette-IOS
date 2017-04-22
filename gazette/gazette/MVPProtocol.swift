//
//  ViewProtocol.swift
//  gazette
//
//  Created by Alireza Ghias on 2/2/1396 AP.
//  Copyright © 1396 AreaTak. All rights reserved.
//

import Foundation
@objc protocol ViewProtocol {
	@objc optional func reload()
}
@objc protocol PresenterProtocol {
	init(_ vc: ViewProtocol)
}
