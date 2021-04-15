//
//  StagePicker.swift
//  DebugApp
//
//  Created by Nail Sharipov on 14.04.2021.
//

import SwiftUI

struct StagePicker: View {

    @ObservedObject private var state: StageState
    private let data = StageState.StageType.allCases
    
    init(state: StageState) {
        self.state = state
    }
    
    var body: some View {
        List(self.data, id: \.self) { test in
            StageRow(test: test, isSelected: self.state.current == test)
                .gesture(TapGesture().onEnded { _ in
                    self.state.current = test
                }
            )
        }
    }

}

struct StagePicker_Previews: PreviewProvider {
    static var previews: some View {
        StagePicker(state: StageState())
    }
}

