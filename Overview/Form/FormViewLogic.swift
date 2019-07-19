//
//  CombineLogic.swift
//  Overview
//
//  Created by Scott OToole on 6/25/19.
//  Copyright © 2019 Scott OToole. All rights reserved.
//

import Foundation
import SwiftUI
import Combine


//bindable object here that fetches data and publishes it

struct Basic : Codable {
	let userID, id: Int
	let title: String
	let completed: Bool
	
	enum CodingKeys: String, CodingKey {
		case userID = "userId"
		case id, title, completed
	}
}

class FormViewLogic : BindableObject {
	
	var willChange : PassthroughSubject<Void, Never> = PassthroughSubject()
	
	public var score = 0 { willSet { willChange.send() } }
	
	public var num = [1,2,3,4,5] { didSet { willChange.send() } }
	
	private(set) var basic : Basic? =  nil { didSet { willChange.send() } }
	
	func getData()  {
		
		let url = URLRequest(url: URL(string: "https://jsonplaceholder.typicode.com/todos/1")!)

		_ = URLSession.shared.dataTaskPublisher(for: url)
			.map { $0.data }
			.decode(type: Basic.self, decoder: JSONDecoder())
			.receive(on : RunLoop.main)
			.sink(receiveCompletion: { (error) in
				print(error)
			}, receiveValue: { self.basic = $0 })
	}
}
