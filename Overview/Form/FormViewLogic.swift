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

struct SomeErrors: Error {
	var code : Int
}


class FormViewLogic : BindableObject {
	
	var willChange : PassthroughSubject<Void, Never> = PassthroughSubject()
	
	var stuff : PassthroughSubject<Basic, Never> = PassthroughSubject()
	
	var stuff2 : PassthroughSubject<Basic, Never> = PassthroughSubject()
	
	public var score = 0 { willSet { willChange.send() } }
	
	public var num = [1,2,3,4,5] { didSet { willChange.send() } }
	
	private(set) var basic : Basic? =  nil { didSet { willChange.send() } }

	func getData()  {
		
		let urla = URLRequest(url: URL(string: "https://jsonplaceholder.typicode.com/todos/1")!)
				
				let urlb = URLRequest(url: URL(string: "https://jsonplaceholder.typicode.com/todos/12")!)

				let fra = URLSession.shared.dataTaskPublisher(for: urla)
					.map {$0.data}
					.decode(type: Basic.self, decoder: JSONDecoder())
				
				let sha = URLSession.shared.dataTaskPublisher(for: urlb)
					.map {$0.data}
					.decode(type: Basic.self, decoder: JSONDecoder())
					
				Publishers.Zip(sha, fra)
					.receive(on: RunLoop.main)
					.sink(receiveCompletion: { (completion) in
						switch completion {
						case .failure(let nev):
							print(nev)
						default:
							print("complete")
						}
					}, receiveValue: { (response) in
						print(response)
					})
		
//		precondition("" == "5")
		
		let url = URLRequest(url: URL(string: "https://jsonplaceholder.typicode.com/todos/1")!)

		_ = URLSession.shared.dataTaskPublisher(for: url)
			.tryMap { data, response  in
				if let r = response as? HTTPURLResponse {
					switch r.statusCode {
					case 200...201:
						return data
					default:
						fatalError()
					}
				}
				return data
			}
			.decode(type: Basic.self, decoder: JSONDecoder())
			.receive(on : RunLoop.main)
			.sink(receiveCompletion: { (response) in
				switch response {
				case .failure(let error):
					print("error: \(error)")
				case .finished:
					break
				}
			}, receiveValue: { print($0) })
		
		
	}
}
