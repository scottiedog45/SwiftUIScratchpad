//
//  Gestures.swift
//  Overview
//
//  Created by Scott OToole on 6/27/19.
//  Copyright © 2019 Scott OToole. All rights reserved.
//

import SwiftUI

struct DraggableCircle: View {

    enum DragState {
        case inactive
        case pressing
        case dragging(translation: CGSize)
        
		//quicker way to group enum states and give values based on those statees
        var translation: CGSize {
            switch self {
            case .inactive, .pressing:
                return .zero
            case .dragging(let translation):
                return translation
            }
        }
        
		
		
        var isActive: Bool {
            switch self {
            case .inactive:
                return false
            case .pressing, .dragging:
                return true
            }
        }
        
        var isDragging: Bool {
            switch self {
            case .inactive, .pressing:
                return false
            case .dragging:
                return true
            }
        }
    }
	
    
    @GestureState var dragState = DragState.inactive
    @State var viewState = CGSize.zero
	
	let minimumLongPressDuration = 0.5
				
	
	var body: some View {
		
		//this is inside the body becuase it references a property of self
		let longPressDrag = LongPressGesture(minimumDuration: minimumLongPressDuration)
			
							.sequenced(before: DragGesture())
			
							.updating($dragState) { value, state, transaction in
								switch value {
								// Long press begins.
								case .first(true):
									state = .pressing
								// Long press confirmed, dragging may begin.
								case .second(true, let drag):
									state = .dragging(translation: drag?.translation ?? .zero)
								// Dragging ended or the long press cancelled.
								default:
									state = .inactive
								}
							}
							.onEnded { value in
								guard case .second(true, let drag?) = value else { return }
								self.viewState.width += drag.translation.width
								self.viewState.height += drag.translation.height
							
		
		}
			
		//returning this explicitly because there is another property in the view property
		 return Circle()
			.fill(Color.blue)
			.overlay(dragState.isDragging ? Circle().stroke(Color.white, lineWidth: 2) : nil)
			.frame(width: 100, height: 100, alignment: .center)
			.offset(
				x: viewState.width + dragState.translation.width,
				y: viewState.height + dragState.translation.height
			)
			.animation(nil)
			.shadow(radius: dragState.isActive ? 8 : 0)
			.animation(Animation.default.delay(minimumLongPressDuration))
			.gesture(longPressDrag)
		}
}
	
	
#if DEBUG
struct Gestures_Previews : PreviewProvider {
    static var previews: some View {
        DraggableCircle()
    }
}
#endif
