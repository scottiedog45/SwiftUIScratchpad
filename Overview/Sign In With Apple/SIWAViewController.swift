//
//  SIWAViewController.swift
//  Overview
//
//  Created by Scott OToole on 6/30/19.
//  Copyright © 2019 Scott OToole. All rights reserved.
//

import Foundation
import UIKit
import SwiftUI
import AuthenticationServices



class SIWAViewController : UIViewController, ASAuthorizationControllerDelegate, ASAuthorizationControllerPresentationContextProviding {
	
	override func viewDidLoad() {
		let ba = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(d))
		
		print("nav: \(self.navigationController.debugDescription)")
		
		self.navigationController?.isToolbarHidden = false
		
		self.navigationController?.setToolbarItems([ba], animated: false)
		
		let b = ASAuthorizationAppleIDButton(type: .continue, style: .black)
		b.translatesAutoresizingMaskIntoConstraints = false
		b.addTarget(self, action: #selector(login), for: .touchUpInside)
		
		view.addSubview(b)
		NSLayoutConstraint.activate([
			b.centerYAnchor.constraint(equalTo: view.centerYAnchor),
			b.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30),
			b.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30)
			])
		
		
	}
	
	@objc
	func d() {
		print("hi")
	}
	
	@objc
	func login() {
		let provider = ASAuthorizationAppleIDProvider()
		let request = provider.createRequest()
		request.requestedScopes = [.email, .fullName]
		
		let controller = ASAuthorizationController(authorizationRequests: [request])
		
		controller.presentationContextProvider = self
		controller.delegate = self
		
		controller.performRequests()
	}
	
	func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
		
		let sd = UIApplication.shared.delegate as? SceneDelegate
		
		return (sd?.window!)!
	}
	
	func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
		
		print("error")
	}
	
	func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
		
		switch authorization.credential {
		case let credentials as ASAuthorizationAppleIDCredential:
			let user = User(credentials: credentials)
			print(user)
			
		default: break
			
		}
	}
}

struct SIWAViewControllerWrapper : UIViewControllerRepresentable {
	
	typealias UIViewControllerType = SIWAViewController
	
	func makeUIViewController(context: UIViewControllerRepresentableContext<SIWAViewControllerWrapper>) -> SIWAViewControllerWrapper.UIViewControllerType {
		print("working")
		return SIWAViewController()
	}
	
	func updateUIViewController(_ pageViewController: SIWAViewControllerWrapper.UIViewControllerType, context: UIViewControllerRepresentableContext<SIWAViewControllerWrapper>) {
		
	}
}

extension View {
	func presentation<T: View>(_ isShown: Binding<Bool>, title: Text, modal: () -> T) -> some View {
		let view = NavigationView {
			modal()
				.navigationBarTitle(title)
				.navigationBarItems(trailing:
					HStack{
						Button(action: {
						isShown.value.toggle()
						}, label: { Text("Done") } )
						Spacer()
						Button(action: {
							isShown.value.toggle()
						}, label: { Text("Done") } )
						Button(action: {
							isShown.value.toggle()
						}, label: { Text("Done") } )
						Button(action: {
						isShown.value.toggle()
						}, label: { Text("Done") } )
						Button(action: {
						isShown.value.toggle()
						}, label: { Text("Done") } )
			})
		}
		
		return presentation(isShown.value ?
			Modal(
				view,
				onDismiss: {
					isShown.value.toggle()
			}
			)
			: nil
		)
	}
}

