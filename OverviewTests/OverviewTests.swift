//
//  OverviewTests.swift
//  OverviewTests
//
//  Created by Scott OToole on 6/25/19.
//  Copyright © 2019 Scott OToole. All rights reserved.
//

import XCTest
@testable import Overview
import SwiftUI
import Combine

struct de : Codable {
	let one, two : String
}


class InvoiceListState : BindableObject {
	
	var willChange : PassthroughSubject<Void, Never> = PassthroughSubject()
	
	var data : de = de(one: "one", two: "two") { willSet {willChange.send() } }
	
	var e : Error? = nil
	
	var b : String? {
		willSet {
			print("hi")
		}
	}
	
	func getData(url : String, prop: de, error: Error) {
//		InvoiceListDTP()
	}
	
}

class bo : BindableObject {
	
//	de(one: "first", two: "second"
	//probably don't need willChange since nothing is subscribing to these values
	var willChange = PassthroughSubject<Void, Never>()
	
	var didCChange = CurrentValueSubject<Int, Never>(1)
	
	var test = de(one: "one", two: "two") { willSet {willChange.send() } }
	
	var errorInt : Int? {willSet {willChange.send() } }
	
	var decodingError : DecodingError? { willSet { willChange.send() } }
	
	func loadJson(filename fileName: String) -> de? {
		let testBundle = Bundle(for: type(of: self))
		let filePath = testBundle.path(forResource: fileName, ofType: "json")
		let fileUrl = URL(fileURLWithPath: filePath!)
		do {
			let data = try! Data(contentsOf: fileUrl, options: .uncached)
			let decoder = JSONDecoder()
			let jsonData = try decoder.decode(de.self, from: data)
			return jsonData
		} catch {
			self.errorInt = 404
			print("error:\(error)")
		}
		return nil
	}
	
	func doStuff() {
		do {
			let jsonData = try JSONEncoder().encode(loadJson(filename: "mock"))
//			let jsonString = String(data: jsonData, encoding: .utf8)!
			
			let remoteDataPublisher = Just(jsonData)
				// the dataTaskPublisher output combination is (data: Data, response: URLResponse)
//				.map { $0.data }
				.decode(type: de.self, decoder: JSONDecoder())
			
			let _ = remoteDataPublisher
				.sink(receiveCompletion: { completion in
					print(".sink() received the completion", String(describing: completion))
					switch completion {
					case .finished:
						break
					case .failure(let anError):
						self.errorInt = 404
						print("received error: ", anError)
					}
				}, receiveValue: { someValue in
					self.test = someValue
					print(".sink() received \(someValue)")
				})
			
		} catch {
			
		}
	}
}

class OverviewTests: XCTestCase {

	func testThings() {
			let b = bo()
		
			b.doStuff()
		
//			let a = b.test
			
//			XCTAssertTrue(a.one == "a")
		
			let a = b.didCChange.value
		
			XCTAssertTrue(a == 1)
		
			XCTAssertTrue(b.errorInt == 404)
	}
	
    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }

    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
