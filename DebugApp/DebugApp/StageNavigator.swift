//
//  StageNavigator.swift
//  DebugApp
//
//  Created by Nail Sharipov on 14.04.2021.
//

import SwiftUI

struct StageNavigator: View {
    
    private let state = StageState()
    
    var body: some View {
        NavigationView {
            StagePicker(state: self.state).frame(width: 200)
            StageView(state: self.state).frame(minWidth: 30)
        }.frame(minWidth: 250, maxWidth: .greatestFiniteMagnitude, minHeight: 200, maxHeight: .greatestFiniteMagnitude)
    }
}

struct StageNavigator_Previews: PreviewProvider {
    static var previews: some View {
        StageNavigator()
    }
}
