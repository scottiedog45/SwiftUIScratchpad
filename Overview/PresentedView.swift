//
//  PresentedView.swift
//  Overview
//
//  Created by Scott OToole on 7/5/19.
//  Copyright © 2019 Scott OToole. All rights reserved.
//

import SwiftUI

struct PresentedView : View {
    var body: some View {
		NavigationView {
			Form {
				Section {
					NavigationLink(destination: FormView()) { Text("I'm presented!")}
				}
			}.navigationBarTitle(Text("I'm presented!"))
			
		}
		
	}
}

#if DEBUG
struct PresentedView_Previews : PreviewProvider {
    static var previews: some View {
        PresentedView()
    }
}
#endif
