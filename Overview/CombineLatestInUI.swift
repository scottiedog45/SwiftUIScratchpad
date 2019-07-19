//
//  CombineLatestInUI.swift
//  Overview
//
//  Created by Scott OToole on 6/29/19.
//  Copyright © 2019 Scott OToole. All rights reserved.
//

import SwiftUI
import Combine

struct CombineLatestInUI : View {
	
	@ObjectBinding var bo : CombineLatestPublisher
	
    var body: some View {
		VStack {
			TextField("hi", text: $bo.first)
				.lineLimit(5)
			TextField($bo.first)
			TextField($bo.second)
			Text(bo.first == bo.second ? "same" : "different")
		}
    }
}

#if DEBUG
struct CombineLatestInUI_Previews : PreviewProvider {
    static var previews: some View {
		CombineLatestInUI(bo: CombineLatestPublisher())
    }
}
#endif
