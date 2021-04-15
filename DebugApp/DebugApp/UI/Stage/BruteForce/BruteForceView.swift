//
//  BruteForceView.swift
//  DebugApp
//
//  Created by Nail Sharipov on 14.04.2021.
//

import SwiftUI

struct BruteForceView: View {

    @ObservedObject var logic: BruteForceLogic
    private let state: DragAreaState
    
    init(state: DragAreaState, logic: BruteForceLogic) {
        self.state = state
        self.logic = logic
    }
    
    var body: some View {
        let points = self.logic.points
        var cities = [DotView.Data]()
        for (i, p) in points.enumerated() {
            cities.append(DotView.Data(index: i, point: p, name: "\(i)"))
        }
        
        let minPath = self.logic.minPath

        return ZStack {
            PathView(state: state, points: minPath)
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
