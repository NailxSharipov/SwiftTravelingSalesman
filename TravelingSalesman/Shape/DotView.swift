//
//  DotView.swift
//  TravelingSalesman
//
//  Created by Nail Sharipov on 07.03.2021.
//

import SwiftUI

struct DotView: View {

    private let color: Color
    private let point: CGPoint
    private let name: String
    private let radius: CGFloat
    @ObservedObject private var state: DragAreaState
    
    struct Data {
        let index: Int
        let point: CGPoint
        let name: String
    }

    init(state: DragAreaState, point: CGPoint, name: String, radius: CGFloat = 5, color: Color = .gray) {
        self.state = state
        self.color = color
        self.radius = radius
        self.point = point
        self.name = name
    }

    var body: some View {
        let screenPoint = state.screen(world: point)
        var textPoint: CGPoint = screenPoint
        if point.y > 0 {
            textPoint.y -= 12
        } else {
            textPoint.y += 12
        }
        
        return ZStack {
            Circle()
                .fill(self.color)
                .frame(width: 2 * radius, height: 2 * radius)
                .position(x: screenPoint.x, y: screenPoint.y)
            Text(name).font(.title2).position(textPoint).foregroundColor(.black)
        }
    }
}
