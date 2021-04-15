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
        let points = self.logic.points
        var cities = [DotView.Data]()
        for (i, p) in points.enumerated() {
            cities.append(DotView.Data(index: i, point: p, name: "\(i)"))
        }
        
        let smartPath = self.logic.smartPath

        return ZStack {
            Path { path in
                let screenPoints = state.screen(world: smartPath)
                path.addLines(screenPoints)
                path.closeSubpath()
            }.strokedPath(.init(lineWidth: 3, lineJoin: .round)).foregroundColor(Color.green)
            ForEach(cities, id: \.index) { city in
                DotView(
                    state: self.state,
                    point: city.point,
                    name: city.name,
                    color: Color.gray
                )
            }
        }
        
    }
    
}
