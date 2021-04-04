//
//  SceneView.swift
//  TravelingSalesman
//
//  Created by Nail Sharipov on 06.03.2021.
//

import SwiftUI

struct SceneView: View {

    @ObservedObject var stageData: StageData
    private let state: DragAreaState
    
    init(state: DragAreaState, stageData: StageData) {
        self.state = state
        self.stageData = stageData
    }

    
    var body: some View {
        let points = self.stageData.points
        var cities = [DotView.Data]()
        for (i, p) in points.enumerated() {
            cities.append(DotView.Data(index: i, point: p, name: "\(i)"))
        }
        
        let greedPaths = self.stageData.smartPath
        let bruteForcePath = self.stageData.bruteForcePath

        if let bruteForcePath = bruteForcePath {
            return AnyView(ZStack {
                Path { path in
                    let screenPoints = state.screen(world: bruteForcePath)
                    path.addLines(screenPoints)
                    path.closeSubpath()
                }.strokedPath(.init(lineWidth: 6, lineJoin: .round)).foregroundColor(Color.gray)
                Path { path in
                    let screenPoints = state.screen(world: greedPaths)
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
            })
        } else {
            return AnyView(ZStack {
                Path { path in
                    let screenPoints = state.screen(world: greedPaths)
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
            })
        }
    }

}
