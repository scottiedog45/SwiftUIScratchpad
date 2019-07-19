//
//  CombineLatestPublisher.swift
//  Overview
//
//  Created by Scott OToole on 6/28/19.
//  Copyright © 2019 Scott OToole. All rights reserved.
//

import Foundation
import Combine
import UIKit
import SwiftUI

extension Notification.Name {
	static let combineLatestToMakeText = Notification.Name("combine_latest_to_make_text")
}

class CombineLatestPublisher : BindableObject {
	
	var willChange: PassthroughSubject<Void, Never> = PassthroughSubject()
	
	var available : Bool = false {
		willSet {
			self.willChange.send()
		}
	}
	
	var first : String = "" {
		willSet {
			self.willChange.send()
		}
	}
	
	var second : String = "" {
		willSet {
			self.willChange.send()
		}
	}
	
	func s() {
	}
}
