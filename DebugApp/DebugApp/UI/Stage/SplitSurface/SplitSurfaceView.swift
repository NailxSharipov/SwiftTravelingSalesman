//
//  SplitSurfaceView.swift
//  DebugApp
//
//  Created by Nail Sharipov on 14.04.2021.
//

import SwiftUI

struct SplitSurfaceView: View {

    @ObservedObject var logic: SplitSurfaceLogic
    private let state: DragAreaState
    
    init(state: DragAreaState, logic: SplitSurfaceLogic) {
        self.state = state
        self.logic = logic
    }
    
    var body: some View {
        let viewModel = self.logic.viewModel

        return ZStack {
//            ForEach(vEds, id: \.index) { edge in
//                EdgeView(
//                    state: self.state,
//                    points: edge.points,
//                    color: Color.edge
//                )
//            }
            ForEach(viewModel.hordes, id: \.index) { edge in
                EdgeView(
                    state: self.state,
                    points: edge.points,
                    color: Color.horde
                )
            }
            ForEach(viewModel.steps, id: \.index) { edge in
                EdgeView(
                    state: self.state,
                    points: edge.points,
                    color: Color.step
                )
            }
            ForEach(viewModel.dots, id: \.index) { dot in
                DotView(
                    state: self.state,
                    point: dot.point,
                    name: dot.name,
                    color: Color.gray
                )
            }
//            PathView(state: state, points: viewModel.circle, lineWidth: 5)
        }
        
    }
    
}

private extension Color {
    
    static let edge = Color(red: 0.2, green: 0.2, blue: 0.2, opacity: 1)
    static let horde = Color(red: 1, green: 0, blue: 0, opacity: 0.1)
    static let step = Color(red: 0, green: 0, blue: 1.0, opacity: 0.4)
}
