//
//  PlayingWithShapes.swift
//  Overview
//
//  Created by Scott OToole on 7/14/19.
//  Copyright © 2019 Scott OToole. All rights reserved.
//

import SwiftUI

struct PlayingWithShapes : View {
	
	@State var spinning : Bool = false
	
	@State var growing : Bool = false
	
	var totalWidth : Int = 100
	
    var body: some View {
		ZStack {
			Circle()
				.trim(from: 0.5, to: 1)
				.stroke(Color.pink, lineWidth: 30)
//				.scaleEffect(spinning ? 0.5 : 0.9)
//				.scaleEffect(1)
				.animation(Animation.linear(duration: 2).repeatForever(autoreverses: true))
				.frame(width: 300, height: 300)
				.rotationEffect(.degrees(spinning ? 360: 0))
				.animation(Animation.linear(duration: 2).repeatForever(autoreverses: false))
				
				.padding()
				.rotation3DEffect(.degrees(45), axis: (x: 1, y: 0, z: 0))
				.animation(Animation.linear(duration: 2).repeatForever(autoreverses: false))
			
			
			Circle()
				.trim(from: 0.5, to: 1)
				.stroke(Color.green, lineWidth: 10)
//				.scaleEffect(spinning ? 0.5 : 1.9)
				.animation(Animation.linear(duration: 2).repeatForever(autoreverses: true))
				.frame(width: 238, height: 238)
				.rotationEffect(.degrees(spinning ? 360: 0))
				.animation(Animation.linear(duration: 4).repeatForever(autoreverses: false))
				.padding()
				.rotation3DEffect(.degrees(45), axis: (x: 1, y: 0, z: 0))
				.animation(Animation.linear(duration: 4).repeatForever(autoreverses: false))
			Circle()
				.trim(from: 0.5, to: 1)
				.stroke(Color.blue, lineWidth: 10)
				//				.scaleEffect(spinning ? 0.5 : 0.9)
				.animation(Animation.linear(duration: 2).repeatForever(autoreverses: true))
				.frame(width: 176, height: 176)
				.rotationEffect(.degrees(spinning ? 0: 360))
				.animation(Animation.linear(duration: 0.8).repeatForever(autoreverses: false))
				.padding()
				.rotation3DEffect(.degrees(45), axis: (x: 1, y: 0, z: 0))
				.animation(Animation.linear(duration: 4).repeatForever(autoreverses: false))
		}
		.padding()
//			.animation(nil)
			
			.onAppear {
//				withAnimation(Animation.default.repeatForever(autoreverses: true)) {
				DispatchQueue.main.async {
					self.spinning.toggle()
				}
					
//				}
				
		
		}
		
		
    }
}

#if DEBUG
struct PlayingWithShapes_Previews : PreviewProvider {
    static var previews: some View {
        PlayingWithShapes()
    }
}
#endif
