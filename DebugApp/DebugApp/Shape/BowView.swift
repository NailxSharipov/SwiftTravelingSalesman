//
//  BowView.swift
//  DebugApp
//
//  Created by Nail Sharipov on 18.04.2021.
//

import SwiftUI

struct BowView: View {

    private let color: Color
    private let isDirect: Bool
    private let description: String?
    private let lineWidth: CGFloat
    private let points: [CGPoint]
    
//    private let arrow: [CGPoint]
    
    @ObservedObject private var state: DragAreaState

    struct Data {
        let index: Int
        let start: CGPoint
        let end: CGPoint
        let length: CGFloat
        let isDirect: Bool
        let description: String?
    }
    
    init(
        state: DragAreaState,
        start: CGPoint,
        end: CGPoint,
        length: CGFloat,
        isDirect: Bool,
        description: String?,
        scale: CGFloat = 0.1, lineWidth: CGFloat = 3, color: Color = .gray) {
        self.state = state
        
        let middle = 0.5 * (start + end)
        let direction = end - start
        let normal = CGPoint(x: -direction.y, y: direction.x)

        let dirLen = (start - end).magnitude.squareRoot()
        
        let s = scale * length / dirLen
        
        let anchor = middle + s * normal
        
        self.points = [start, end, anchor]
        
//        let uDir = direction.normalize
//        let uNor = CGPoint(x: -uDir.y, y: uDir.x)
//        let arrO = end - 1 * uDir
//
//        let arrN = 0.5 * uNor
//
//        let arrA = arrO + arrN
//        let arrB = arrO - arrN
//
//        self.arrow = [arrA, end, arrB]

        self.description = description
        self.isDirect = isDirect
        self.lineWidth = lineWidth
        self.color = color
    }

    var body: some View {
        let bowPoints = state.screen(world: self.points)
//        let arrPoints = state.screen(world: self.arrow)

        if isDirect {
            Path { path in
                path.move(to: bowPoints[0])
                path.addLine(to: bowPoints[1])
            }.strokedPath(.init(lineWidth: lineWidth, lineCap: .round)).foregroundColor(color)
        } else {
//            let radius: CGFloat = 4
            let middle = bowPoints[2]
            let name = description!
//            let dotPos = middle
            let txtPos = middle + CGPoint(x: 0, y: 3)
            ZStack {
                Path { path in
                    path.move(to: bowPoints[0])
                    path.addQuadCurve(to: bowPoints[1], control: middle)
                }.strokedPath(.init(lineWidth: lineWidth, lineCap: .round)).foregroundColor(color)
//                Circle()
//                    .fill(self.color)
//                    .frame(width: 2 * radius, height: 2 * radius)
//                    .position(dotPos)
                Text(name).font(.title2).position(txtPos).foregroundColor(.gray)
            }
        }
    }
}
