//
//  RootTabs.swift
//  Overview
//
//  Created by Scott OToole on 6/27/19.
//  Copyright © 2019 Scott OToole. All rights reserved.
//

import SwiftUI

struct RootTabs : View {
    var body: some View {
		VStack {
//			Text("What")
//		Text("what")
		TabbedView {
			PlayingWithShapes()
				.tabItem {
					Text("shapes")
			}
//			Ani()
//				.tabItemLabel(
//					Text("Ani")
//			).tag(0)
			FormView()
				.tabItem {
					Text("Form")
			}
//			CombineLatestInUI(bo: CombineLatestPublisher())
//			.tabItemLabel(Text("Gestures"))
//			.tag(2)
////			SignInWithAppleScreen()
////			.tabItemLabel(Text("SIWA"))
////			.tag(3)
			}
		}
    }
}

#if DEBUG
struct RootTabs_Previews : PreviewProvider {
    static var previews: some View {
        RootTabs()
    }
}
#endif
