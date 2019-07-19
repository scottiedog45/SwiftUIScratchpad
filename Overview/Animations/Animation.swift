//
//  Animation.swift
//  Overview
//
//  Created by Scott OToole on 6/27/19.
//  Copyright © 2019 Scott OToole. All rights reserved.
//

import SwiftUI
import Combine

struct Ani : View {
	
	@State var length : Length = 50
	
	let v = "5"
	
	@ObjectBinding var logic = FormViewLogic()
	
	func d() {
		logic.num.removeLast()
		print("deleted")
	}
	
	@Published var someBool : Bool = false
	
	
	
	@State var color : Color = .blue
	
	@State var isPresented = false
	
	@State var test : Bool = false
	
	@State var font : Font = .largeTitle
	
	
	
    var body: some View {
		NavigationView {
		VStack {

			Capsule()
				.fill(color)
				.frame(height: length, alignment: .bottom)
				.animation(.spring())
			
			Text("Animation")

			Button(
				action: {
					self.test.toggle()
					self.color = .green
					self.length += 10
				}){
				Text(String(format: NSLocalizedString(" - %@ Notifica", comment: ""), v))
			}
			
			Button(action: {
				self.test.toggle()
				self.color = .blue
				self.length -= 10
			}){
				Text("Smaller")
			}
			
			
			
			List {
				ForEach(logic.num) {_ in
					SubAni(isOn: self.$test)
				}
				.onDelete { _ in
					self.d()
				}
			
			
				
				
//				SubAni(isOn: $test)
//				SubAni(isOn: $test)
//				SubAni(isOn: $test)
			}
			
			.listStyle(.grouped)
		}
			
			.animation(.basic())
			.onAppear {
				DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
					self.test.toggle()
				}
			}
			.navigationBarItems(trailing: Button(action: {
				print("hi")
				self.isPresented = true
			}) {Text("yo")})
			.presentation($isPresented, title: Text("something"), modal: { SignInWithAppleScreen()
			})
			.navigationBarTitle(Text("hi"))
		}
    }
}

struct Leading : View {
	var body : some View {
		Text("hi")
	}
}

struct SubAni : View {
	
	@Binding var isOn : Bool
	
	var body : some View {
//		ScrollView{
			HStack {
//				ScrollView {
				VStack {
					Toggle(isOn: $isOn) {
						Text("hi")
						}
						.animation(.basic())
					Toggle(isOn: $isOn) {
						Text("oi")
						}
						.animation(.basic())
					
				}
			VStack {
				Toggle(isOn: $isOn) {
					Text("hi")
					}
					.animation(.basic())
				Toggle(isOn: $isOn) {
					Text("hi")
					}
					.animation(.basic())
			}
			
			VStack {
				Toggle(isOn: $isOn) {
					Text("hi")
				}
				.animation(.basic())
				Toggle(isOn: $isOn) {
					Text("hi")
				}
				.animation(.basic())
			}
		}
	}
}

#if DEBUG
struct Animation_Previews : PreviewProvider {
    static var previews: some View {
        Ani()
    }
}
#endif
