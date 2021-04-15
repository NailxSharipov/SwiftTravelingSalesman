//
//  PathView.swift
//  DebugApp
//
//  Created by Nail Sharipov on 15.04.2021.
//

import SwiftUI

struct PathView: View {

    private let color: Color
    private let lineWidth: CGFloat
    private let points: [CGPoint]
    @ObservedObject private var state: DragAreaState

    init(state: DragAreaState, points: [CGPoint], lineWidth: CGFloat = 3, color: Color = .gray) {
        self.state = state
        self.points = points
        self.lineWidth = lineWidth
        self.color = color
    }

    var body: some View {
        let screenPoints = state.screen(world: points)
        
        return ZStack {
            Path { path in
                path.addLines(screenPoints)
                path.closeSubpath()
            }.strokedPath(.init(lineWidth: lineWidth, lineJoin: .round)).foregroundColor(color)
        }
    }
}
