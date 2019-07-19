//
//  Gestures.swift
//  Overview
//
//  Created by Scott OToole on 6/27/19.
//  Copyright © 2019 Scott OToole. All rights reserved.
//

import SwiftUI

struct Gestures : View {
	
	@State private var dragged = CGSize.zero

	
    var body: some View {
		VStack {
		Capsule()
			.fill(Color.green)
			.frame(width: 20, height: 20, alignment: .bottom)
			.animation(.default)
			
		Text(/*@START_MENU_TOKEN@*/"Hello World!"/*@END_MENU_TOKEN@*/)
//			.animation(.basic())
			.offset(x: dragged.width, y: dragged.height)
			.gesture(
				DragGesture(minimumDistance: 50)
					.onChanged { value in
						self.dragged = value.translation
				}
					.onEnded { value in
						self.dragged = CGSize.zero
				})
		.animation(.spring())
    }
	}
}

#if DEBUG
struct Gestures_Previews : PreviewProvider {
    static var previews: some View {
        Gestures()
    }
}
#endif
