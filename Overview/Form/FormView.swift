//
//  FormView.swift
//  Overview
//
//  Created by Scott OToole on 6/27/19.
//  Copyright © 2019 Scott OToole. All rights reserved.
//

import SwiftUI

struct MultilineTextView: UIViewRepresentable {
	@Binding var text: String
	
	func makeUIView(context: Context) -> UITextView {
		let view = UITextView()
		view.isScrollEnabled = true
		view.isEditable = true
		view.isUserInteractionEnabled = true
		return view
	}
	
	func updateUIView(_ uiView: UITextView, context: Context) {
		uiView.text = text
	}
}

struct FormView : View {
	var strengths = ["Mild", "Medium", "Mature"]
	
	@ObjectBinding var combineExample = FormViewLogic()
	
	@ObjectBinding var s = NetworkingState()
	
	@State var isPresented = false
	
	@State var selectedStrength = 0
	
	@State var text : String = "d"
	
	@State var date = Date()
	
	@State var boolean = true
	
	@State var int = 4
	
	var body: some View {
		Text("hi")
//		NavigationView {
////			PresentationLink(destination: PresentedView(), label: "hi")
//			Form {
//				Section(header: Text("multiline")) {
//					Text("")
//					MultilineTextView(text: $text)
////						.height(400)
//				}
//				Section(header: Text("test")) {
//					Text("Lorem ipsum dolor sit amet, consectetur adipiscing elit. Suspendisse est leo, vehicula eu eleifend non, auctor ut arcu")
//						.lineLimit(nil)
//				}
//				Section(header: Text("Section Title")) {
//					Picker(selection: $selectedStrength, label: Text("Strength")) {
//						ForEach(0 ..< strengths.count) {
//							Text(self.strengths[$0]).tag($0)
//
//						}
//					}
//				}
//				Section(header: Text("Sleep tracking settings")) {
//					Toggle(isOn: $boolean) {
//						Text("Sleep tracking:")
//					}
//
//					//min max stepper value
//					Stepper(value: $combineExample.score, in: 0...12) {
//						Text("Sleep goal is \(combineExample.score) hours")
//					}
//				}
//
//
//				Section {
//					NavigationLink(destination: Ani()) {
//						Text(text)
//					}
//				}
//				Section {
//					Text("fail")
////					PresentationLink(destination: PresentedView(), label: "test")
//				}
//				Section {
//					TextField("what", text: $text)
//				}
////				Section {
////					DatePicker(
////					DatePicker($date, minimumDate: Calendar.current.date(byAdding: .year, value: -1, to: Date()), maximumDate: Calendar.current.date(byAdding: .year, value: 1, to: Date()), displayedComponents: .date)
////				}
//
//				}
//
//
//			.navigationBarTitle(Text("Select your cheese"))
//
//			}
//
//
			.onAppear {
				self.combineExample.getData()
				self.s.getTokenOldSchool()
//				CombineNotification().setStuffUp()
		}
//		.edgesIgnoringSafeArea(.top)
	}
}

#if DEBUG
struct FormView_Previews : PreviewProvider {
    static var previews: some View {
        FormView()
    }
}
#endif
