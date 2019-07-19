//
//  SignInWithAppleScreen.swift
//  Overview
//
//  Created by Scott OToole on 6/30/19.
//  Copyright © 2019 Scott OToole. All rights reserved.
//

import SwiftUI
import AuthenticationServices

struct SignInWithAppleScreen : View {
	
    var body: some View {
		NavigationView {
			SIWAViewControllerWrapper()
		}
	}
}


#if DEBUG
struct SignInWithAppleScreen_Previews : PreviewProvider {
    static var previews: some View {
        SignInWithAppleScreen()
    }
}
#endif
