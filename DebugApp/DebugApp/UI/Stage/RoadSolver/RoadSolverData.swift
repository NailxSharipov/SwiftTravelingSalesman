//
//  RoadSolverData.swift
//  DebugApp
//
//  Created by Nail Sharipov on 25.04.2021.
//

import CoreGraphics

struct RoadSolverData {

    struct Data {
        let points: [CGPoint]
        
        init(_ points: [CGPoint]) {
            self.points = points
        }
    }

    static let data: [Data] = [
        Data([
            CGPoint(x: -15, y:  15),
            CGPoint(x:  15, y:  15),
            CGPoint(x:  15, y: -15),
            CGPoint(x: -15, y: -15)
        ]),
        Data([
            CGPoint(x: -15, y:  10),
            CGPoint(x:  -5, y:  -5),
            CGPoint(x:   5, y:   5),
            CGPoint(x:  15, y: -10)
        ]),
        Data([
            CGPoint(x: -20, y:  -5),
            CGPoint(x: -10, y:   5),
            CGPoint(x:  1.5, y: -1.5),
            CGPoint(x:  10, y:   5),
            CGPoint(x:  20, y:  -5)
        ]),
        Data([
            CGPoint(x: -20, y:  -5),
            CGPoint(x: -10, y:   5),
            CGPoint(x:   0, y:   0),
            CGPoint(x:  10, y:   5),
            CGPoint(x:  20, y:  -5)
        ]),
        Data([
            CGPoint(x:  -5, y:  15),
            CGPoint(x:-5.5, y: 5.5),
            CGPoint(x:  15, y:  -5),
            CGPoint(x:   5, y: -15),
            CGPoint(x:  -5, y: -15),
            CGPoint(x: -10, y:  -5),
            CGPoint(x: -15, y:  -5),
            CGPoint(x: -15, y:   5)
        ]),
        Data([
            CGPoint(x:  -5, y:  15),
            CGPoint(x:   5, y:  15),
            CGPoint(x:  15, y:   5),
            CGPoint(x:  15, y:  -5),
            CGPoint(x:   5, y: -15),
            CGPoint(x:  -5, y: -15),
            CGPoint(x: -15, y:  -5),
            CGPoint(x: -15, y:   5)
        ]),
        Data([
            CGPoint(x: -25, y:   0),
            CGPoint(x: -15, y: -15),
            CGPoint(x: -10, y:  15),
            CGPoint(x: -10, y:  -5),
            
            CGPoint(x:   0, y:   5),
            CGPoint(x:  10, y:   5),
            CGPoint(x:  15, y: -15),
            CGPoint(x:  20, y:  15),
            CGPoint(x:  30, y:   0)
        ]),
        Data(Self.circles(n: 3, radiuses: [5, 10])),
        Data(Self.circles(n: 16, radiuses: [25])),
        Data(Self.circles(n: 24, radiuses: [25])),
        Data(Self.circles(n: 3, radiuses: [5, 10, 20])),
        Data(Self.circles(n: 5, radiuses: [5, 10, 20]))
    ]


    private static func circles(n: Int, radiuses: [CGFloat]) -> [CGPoint] {
        var points = [CGPoint]()
        points.reserveCapacity(n * radiuses.count)

        let dA = 2 * CGFloat.pi / CGFloat(n)

        for radius in radiuses {
            var a: CGFloat = 0
            for _ in 0..<n {
                let x: CGFloat = radius * sin(a)
                let y: CGFloat = radius * cos(a)
                points.append(CGPoint(x: x, y: y))
                a += dA
            }
        }

        return points
    }
}
