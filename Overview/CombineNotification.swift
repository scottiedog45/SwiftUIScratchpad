//
//  CombineNotification.swift
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
	static let latinText = Notification.Name("latin_text")
}

class CombineNotification : BindableObject {
	
	var willChange: PassthroughSubject<Void, Never> = PassthroughSubject()
	
	var b : Basic? = nil {
		willSet {
			willChange.send()
		}
	}
	//create did change method here and make this a bindable protocol
	func setStuffUp() {
		//consolidate verion
		
		let lastLatinTextLabel = UILabel()
		
		 _ = NotificationCenter.Publisher(center: .default, name: .latinText, object: nil)
			.map { (notification) -> String? in
				return (notification.object as? Basic)?.title ?? ""}
			.assign(to: \.text, on: lastLatinTextLabel)
		
//		assign to in place of the below code
//		let lastLatinTextSubscriber = Subscribers.Assign(object: lastLatinTextLabel, keyPath: \.text)
		
//		latinTextPublisher.subscribe(lastLatinTextSubscriber)
		
//		The text property of the label requires to receive a String? value while the stream publishes a Notification. Therefore, we need to use an operator you might be familiar with already: map. Using this operator we can change the output value from a Notification to the required String? type.
	
		let lt = Basic(userID: 1, id: 1, title: "some latin", completed: true)
		
		NotificationCenter.default.post(name: .latinText, object: lt)
		print("latin text is:\(lastLatinTextLabel.text)")
	}
}
